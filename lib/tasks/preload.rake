namespace :preload do
  require 'ruby-progressbar'

  desc 'Preloads images from a csv file of solr ids'
  task :from_file, [:path] => :environment do |_t, args|

    length = CSV.read(args.path).length
    progress = ProgressBar.create(
      title: 'Processing Cover Images:',
      total: length,
      format: "%t %a %E | completed: %c/#{length} |%w%i|"
    )
    @book_types = %w(book)
    @music_types = %w(CD LP Cassete)
    @statuses = %w(done error)

    CSV.foreach(args.path, headers: true, header_converters: :symbol) do |row|
      progress.increment
      if (@statuses =~ /(error).*$|(saved)/) ||
          row[:id].nil? ||
          CoverImage.find_by(doc_id: row[:id]).present?
        # already checked
        next
      end

      response = HTTParty.get(
        'http://libsvr40.lib.virginia.edu:8985/solr/bib/select',
        query: {
          q:  "id:#{row[:id]}",
          wt: 'json'
        }
      )
      if (record = JSON.parse(response.body)['response']['docs'].first)
        ci = cover_image_from_solr(record)
        row[:status] =
          if ci.save
            'saved'
          else
            "error: #{ci.errors.to_a}"
          end

      end
    end
  end


  def get_doc_type(record)
    formats = record['format_facet']

    if (formats & @music_types).any? && (formats & @book_types).none?
      'music'
    else
      'non_music'
    end
  end

  def cover_image_from_solr(record)
    title = record['title_display'].try :first
    doc_type = get_doc_type record

    isbn = record['isbn_display'].try :first
    oclc = record['oclc_display'].try :first
    lccn = record['lccn_display'].try :first
    upc  = record['upc_display'].try :first

    album  = title
    artist = record['author_facet'].try :first

    CoverImage.new(
      doc_id: record['id'], title: title, doc_type: doc_type,
      isbn: isbn, oclc: oclc, lccn: lccn, upc: upc,
      artist_name: artist, album_name: album,
      run_lookup: true
    )
  end

  desc 'Loads locked images from source control'
  task :locked_images, [] => :environment do |_t|
    locked_img_dir = Rails.root.join('locked_images')
    Dir.entries(locked_img_dir).each do |file|
      file_path = File.join(locked_img_dir, file)
      next unless File.file?(file_path)
      file_name = File.basename(file, '.*')
      c = CoverImage.find_or_initialize_by(
        doc_id: file_name, doc_type: 'non_music', isbn: file_name, locked: true,
        status: 'processed'
      )
      if c.new_record?
        puts "#{file_name} created."
      else
        puts "#{file_name} exists."
      end

      File.open(file_path) do |file_io|
        # save the images
        c.image = file_io
        c.save
      end
    end
  end
end

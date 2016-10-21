namespace :preload do
  require 'ruby-progressbar'

  desc "Preloads images from "
  task :from_file, [:path] => :environment do |t, args|


    length = CSV.read(args.path).length
    progress = ProgressBar.create(title: "Processing Cover Images:", total: length, format: "%t %a %E | completed: %c/#{length} |%w%i|")
    @book_types ||= ['book']
    @music_types ||= ['CD', 'LP', 'Cassete']

    CSV.foreach(args.path, headers: true, header_converters: :symbol) do |row|
      progress.increment
      if CoverImage.find_by doc_id: row[:id]
        # already exists
        next
      end

      response = HTTParty.get("http://libsvr40.lib.virginia.edu:8985/solr/bib/select",
                              {query: {
                                q: "id:#{row[:id]}",
                                wt: "json"
                              }})
      #TODO check for more than 1 doc
      if record = JSON.parse(response.body)["response"]['docs'].first

        title = record['title_display']

        isbn = record['isbn_display'].try :first
        oclc = record['oclc_display'].try :first
        lccn = record['lccn_display'].try :first
        upc  = record['upc_display'].try :first

        ci = CoverImage.new(title: title, doc_type: doc_type,
                          isbn: isbn, oclc: oclc, lccn: lccn, upc: upc,
                          artist_name: artist, album_name: album,
                          run_lookup: true
                         )
        if ci.save
        else

        end

      end
    end
    def determine_doc_type record
      formats = record['format_facet']

      if  (formats & @music_types).any? && (formats & @book_types).none?
        return 'music'
      else
        return 'non_music'
      end
    end
  end
end

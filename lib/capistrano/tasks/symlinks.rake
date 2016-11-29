namespace :deploy do
  desc "symlink the image folder to the path set by :image_folder_symlink. Use an absolute path."
  task :symlink_images do |t|
    on roles(:app) do
      dest = shared_path.join('public/system')
      if test("if [ -L #{dest} ]; then exit 0; else exit 1; fi ")
        puts "Images are already symlinked"
        next
      end
      if source = fetch(:image_folder_symlink)
        source = Pathname.new(source).join('system')
        public_folder = shared_path.join('public')

        existing_dest = Dir.exist? (dest + '/')

        execute :mkdir, '-p', source
        if existing_dest
          puts "Moving existing images, linking, and restoring images"
          tmp_images = shared_path.join('public/system_old')
          execute :mv, dest, tmp_images
          execute :ln, "-snf", source, public_folder
          execute :mv, (tmp_images + '*'), dest
          execute :rm, '-r', tmp_images
        else
          puts "creating linked public/system folder"
          execute :ln, "-snf", source, public_folder
        end
      else
        puts ":image_folder_symlink is not set. The local drive will probably fill up."
      end
    end
  end
end

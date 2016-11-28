namespace :logs do
  desc "Tail logs from the given file"
  task :tail, :file do |t, args|
    if args[:file]
      on roles(:app) do
        execute "tail -f #{shared_path}/log/#{args[:file]}.log"
      end
    else
      puts "please specify a logfile e.g: 'rake logs:tail[logfile]"
      puts "will tail 'shared_path/log/logfile.log'"
      puts "remember if you use zsh you'll need to format it as:"
      puts "rake 'logs:tail[logfile]' (single quotes)"
    end
  end

  desc "Lists available log files"
  task :ls do |t|
    on roles(:app) do
      execute "ls #{shared_path}/log"
    end
  end
end

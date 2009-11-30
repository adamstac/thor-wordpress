class Deploy < Thor

  # SSH user information
  SSH_USER = "user@domain.com"
  
  # Remote file location that rsync will deploy to
  REMOTE_ROOT = "~/path/to/remote/root/"
  
  default_task :theme
  
  desc "theme", "Deploys the theme"
  def theme
    system "thor theme:generate"
    puts "*** Deploying the site ***"
    system "rsync -avz --delete . #{SSH_USER}:#{REMOTE_ROOT}"
  end

end
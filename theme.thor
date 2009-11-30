class Theme < Thor
  
  # SSH user information
  SSH_USER = "user@domain.com"
  
  # Remote file location that rsync will deploy to
  REMOTE_ROOT = "~/path/to/remote/root/"
  
  desc "deploy", "Deploys the theme"
  def deploy
    puts "*** Deploying the site ***"
    system "rsync -avz --delete . #{SSH_USER}:#{REMOTE_ROOT}"
  end
  
  desc "styles_clear", "Clears the themes styles"
  def styles_clear
    puts "*** Clearing styles ***"
    system "rm -Rfv css/*"
  end

  desc "styles_generate --clear", "Generates the themes styles."
  method_options :clear => :bolean
  def styles_generate
    if options.clear?
      invoke :clear_styles
    end
    puts "*** Generating styles ***"
    system "compass"
  end

end
class Wordpress < Thor
  
  desc "install", "Download and unpack WordPress from the interwebs"
  method_options :directory => :string, :version => :string
  def install
    opts = {'directory' => '.', 'version' => 'latest'}
    opts = opts.merge(options)
    
    if yes?("Download and install WordPress version '#{opts['version']}' to #{opts['directory'] == '.' ? 'current folder' : opts['directory']}?")
      opts['version'] = "wordpress-#{opts['version']}" unless opts['version'] == 'latest'
      system "mkdir -p #{opts['directory']}" unless opts['directory'] == '.'
      cmd =   "curl http://wordpress.org/#{opts['version']}.tar.gz"
      cmd +=  " | tar -zxv "
      cmd +=  " -C #{opts['directory']} " unless opts['directory'] == '.'
      cmd +=  " --strip 1"
      system cmd      
      if yes?("Download and install thematic?")
        cmd = "curl -O http://wordpress.org/extend/themes/download/thematic.0.9.5.1.zip && unzip thematic.0.9.5.1.zip -d #{opts['directory']}/wp-content/themes && rm thematic.0.9.5.1.zip"
        system cmd
      end
    else
      puts 'Installation aborted'
    end
  end
  
end
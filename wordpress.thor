module Wordpress

  class Install < Thor

    namespace :wordpress
  
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
        say 'Installation aborted'
      end
    end
  
  end

  class Theme < Thor
  
    default_task :install
  
    desc "install --theme=<theme>", "Unpacks the specified <theme> from the compass-wordpress gem"
    method_options :directory => :string, :theme => :string
    def install
      opts = {'directory' => '.', 'theme' => 'thematic'}
      opts = opts.merge(options)

      say "*** Installing Child Theme ***"
      cmd = "compass -r compass-wordpress -f wordpress --sass-dir=sass --css-dir=css -s compressed -p #{opts['theme']} #{opts['directory']}"
      system cmd
      say "*** Installing deploy.thor ***"
      # system "curl -O http://github.com/adamstac/thor-wordpress/raw/master/deploy.thor"
    end

  end

  class Styles < Thor
  
    default_task :generate

    desc "generate", "Clears and Generates the styles"
    def generate
      invoke :clear
      say "*** Generating styles ***"
      system "compass"
    end

    desc "clear", "Clears the styles"
    def clear
      say "*** Clearing styles ***"
      system "rm -Rfv css/*"
    end

  end

  class Compass < Thor
  
    default_task :watch

    desc "watch", "Runs compass --watch"
    def watch
      system "compass --watch"
    end

  end

  class Deploy < Thor
  
    default_task :theme
  
    desc "theme", "Deploys the theme"
    def theme
      config = YAML.load_file("deploy.yaml") rescue nil
      if config
        ssh_user = config['ssh_user']
        remote_root = config['remote_root']
      else
        ssh_user = ask("What is your ssh username?")
        remote_root = ask("What is your remote root path?")
      end
      say "*** Deploying the site ***"
      say "rsync -avz --delete . #{ssh_user}:#{remote_root}"
    end
  
    desc "generate_config", "Asks for ssh_user and remote_root, and generates the deploy.yaml file"
    def generate_config
      filename = "deploy.yaml"
      config = {}
      config['ssh_user'] = ask("What is your ssh username?")
      config['remote_root'] = ask("What is your remote root path?")
      File.open(filename, "w"){ |f| f.puts config.to_yaml }
      say "*** Generated #{File.expand_path filename} ***" 
    end

  end

end
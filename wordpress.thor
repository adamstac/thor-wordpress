module Wp

  class Install < Thor

    default_task :app
  
    desc "app", "Download and unpack WordPress from the interwebs"
    method_options :directory => :string, :version => :string
    def app
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
        if yes?("Download and install Starkers?")
          cmd = "curl -O http://elliotjaystocks.com/starkers/download/latest.zip && unzip latest.zip -d #{opts['directory']}/wp-content/themes && rm latest.zip"
          system cmd
        end
      else
        say 'Installation aborted'
      end
    end
    
    desc "theme --themename=<theme> --directory=<directory>", "Unpacks the specified <theme> from the compass-wordpress gem (Default task)"
    method_options :directory => :string, :themename => :string
    def theme
      opts = {'directory' => '.', 'themename' => 'thematic'}
      opts = opts.merge(options)
      system "mkdir -p #{opts['directory']}" unless opts['directory'] == '.'
      say "*** Installing Child Theme ***"
      cmd = "compass -r compass-wordpress -f wordpress --sass-dir=sass --css-dir=css -s compressed -p #{opts['themename']} #{opts['directory']}"
      system cmd
      #invoke "wp:deploy:generate_config"
    end
  
  end

  class Styles < Thor
  
    default_task :generate

    desc "generate", "Clears and Generates the styles (Default task)"
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
    
    desc "watch", "Runs compass --watch"
    def watch
      invoke "wp:styles:generate"
      system "compass --watch"
    end

  end

  class Deploy < Thor
  
    default_task :theme
  
    desc "theme", "Deploys the theme (Default task)"
    def theme
      config = YAML.load_file("deploy.yaml") rescue nil
      if config
        ssh_user = config['ssh_user']
        remote_root = config['remote_root']
        current_theme = config['current_theme']
      else
        invoke "wp:deploy:generate_config"
      end
      invoke "wp:styles:generate"
      say "*** Deploying the theme ***"
      system "rsync -avz --delete . #{ssh_user}:#{remote_root}/wp-content/themes/#{current_theme}/"
    end

    desc "app", "Deploys the app"
    def app
      config = YAML.load_file("deploy.yaml") rescue nil
      if config
        ssh_user = config['ssh_user']
        remote_root = config['remote_root']
      else
        invoke "wp:deploy:generate_config"
      end
      invoke "wp:styles:generate"
      say "*** Deploying the app ***"
      system "rsync -avz --delete . #{ssh_user}:#{remote_root}/"
    end
  
    desc "generate_config", "Asks for ssh_user and remote_root, and generates the deploy.yaml file"
    def generate_config
      filename = "deploy.yaml"
      config = {}
      config['ssh_user'] = ask("What is your ssh username?")
      config['remote_root'] = ask("What is your remote root path?")
      config['current_theme'] = ask("What is theme name you will use?")
      File.open(filename, "w"){ |f| f.puts config.to_yaml }
      say "*** Generated #{File.expand_path filename} ***" 
    end

  end

end
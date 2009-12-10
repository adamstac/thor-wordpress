module Wp

  class Install < Thor

    default_task :wordpress
  
    desc "wordpress [--thematic]", "Download and unpack WordPress from the interwebs (Default task)"
    method_options :directory => :string, :version => :string, :thematic => :boolean
    def wordpress
      opts = {'directory' => '.', 'version' => 'latest'}
      opts = opts.merge(options)
      opts['version'] = "wordpress-#{opts['version']}" unless opts['version'] == 'latest'
      system "mkdir -p #{opts['directory']}" unless opts['directory'] == '.'
      cmd =   "curl http://wordpress.org/#{opts['version']}.tar.gz"
      cmd +=  " | tar -zxv "
      cmd +=  " -C #{opts['directory']} " unless opts['directory'] == '.'
      cmd +=  " --strip 1"
      system cmd
      if options.thematic?
        cmd = "curl -O http://wordpress.org/extend/themes/download/thematic.0.9.5.1.zip && unzip thematic.0.9.5.1.zip -d #{opts['directory']}/wp-content/themes && rm thematic.0.9.5.1.zip"
        system cmd
      end
    end
    
    # Template for creating your own method for your own theme
    # desc "theme", "Download and unpack <theme> from the interwebs"
    # def <theme>
    #   cmd = "curl -O http://yourdomain.com/theme.zip && unzip -q theme.zip -d . && rm theme.zip"
    #   system cmd
    #   invoke "wp:generate:deploy_yaml"
    # end
    
    desc "theme --themename=<theme> --directory=<directory>", "Unpacks the specified <theme> from the compass-wordpress gem"
    method_options :directory => :string, :themename => :string
    def theme
      opts = {'directory' => '.', 'themename' => 'thematic'}
      opts = opts.merge(options)
      system "mkdir -p #{opts['directory']}" unless opts['directory'] == '.'
      say "*** Installing Theme ***"
      cmd = "compass -r compass-wordpress -f wordpress --sass-dir=sass --css-dir=css -s compressed -p #{opts['themename']} #{opts['directory']}"
      system cmd
      invoke "wp:generate:deploy_yaml"
    end
  
  end

  class Styles < Thor
  
    default_task :generate

    desc "generate", "Clears and Generates the styles (Default task)"
    def generate
      config = load_file("config.rb") rescue nil
      if config
        invoke :clear
        say "*** Generating styles ***"
        system "compass"
      else
        say "\n!! Styles were not generated. Compass is not setup."
      end
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
        invoke "wp:generate:deploy_yaml"
      end
      invoke "wp:styles:generate"
      say "*** Deploying the theme ***"
      system "rsync -avz --delete . #{ssh_user}:#{remote_root}/wp-content/themes/#{current_theme}/"
    end

    desc "app", "Deploys the app"
    def app
      filename = "deploy.yaml"
      config = YAML.load_file(filename) rescue nil
      if config
        ssh_user = config['ssh_user']
        remote_root = config['remote_root']
        invoke "wp:styles:generate"
        say "*** Deploying the app ***"
        system "rsync -avz --delete . #{ssh_user}:#{remote_root}/"
      else
        say "\n!! Deploy not possible. A #{filename} file is required."
        invoke "wp:generate:deploy_yaml"
      end
    end

  end
  
  class Generate < Thor

    desc "deploy_yaml", "Asks for ssh_user and remote_root, and generates the deploy.yaml file"
    def deploy_yaml
      filename = "deploy.yaml"
      config = {'ssh_user' => 'you@yourdomain.com', 'remote_root' => '~/domains/yourdomain.com/html', 'theme' => 'kubrick'}
      File.open(filename, "w"){ |f| f.puts config.to_yaml }
      say "\nA #{filename} file was generated for you. Update this file's information for rsync deployment."
      say "File location: #{File.expand_path filename}"
    end

  end

end
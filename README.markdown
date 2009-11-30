## Thor WordPress: A set of Thor tasks to make developing with WordPress easier

Before you go ANY FURTHER, using these Thor tasks assumes you have the `haml`, `compass` and `compass-wordpress` gems installed.

## Install the Thor tasks:

    thor install http://github.com/adamstac/thor-wordpress/raw/master/wordpress.thor

## Install WordPress with Thor

Change directory to the directory you want to install WordPress in. You'll be asked if you want to install [Thematic](http://themeshaper.com/thematic/). These instructions assume you say yes.

    cd ~/Sites/mysite/
    thor wordpress:install

Change directory to the theme directory

    cd wp-content/themes/

Create your new theme directory

    mkdir mytheme
    cd mytheme/

Install your new theme with Thor. This assumes that you said yes to using installing Thematic and by default unpacks the Thematic project template located inside the Compass-WordPress gem.

    thor wordpress:theme:install
    
## Use rsync to deploy your theme

Generate deploy.yaml to using this command. You will be asked for your ssh_user and remote_root details and Thor will create deploy.yaml for you and add it to the current directory.

    thor wordpress:deploy:generate_config
    
Once that's in place you can run this command to deploy your theme to your server.

    thor wordpress:deploy:theme

## Thor-WordPress tasks

    wordpress
    ---------
    wordpress:install [--directory=DIRECTORY] [--version=VERSION]
    # Download and unpack WordPress from the interwebs
 
    wordpress:theme
    ---------------
    wordpress:theme:install --theme=<theme> [--directory=DIRECTORY] [--theme=THEME]
    # Unpacks the specified <theme> from the compass-wordpress gem
 
    wordpress:styles
    ----------------
    wordpress:styles:generate
    # Clears and Generates the styles
 
    wordpress:styles:clear
    # Clears the styles
 
    wordpress:compass
    -----------------
    wordpress:compass:watch
    # Runs compass --watch
 
    wordpress:deploy
    ----------------
    wordpress:deploy:theme
    # Deploys the theme
 
    wordpress:deploy:generate_config
    # Asks for ssh_user and remote_root, and generates the deploy.yaml file
    
## Contributors

[Adam Stacoviak](http://adamstacoviak.com/) and [Wynn Netherland](http://wynnnetherland.com/)
    
## License

See LICENSE
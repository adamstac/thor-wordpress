## Thor WordPress: A set of Thor tasks to make developing with WordPress easier

Before you go ANY FURTHER, using these Thor tasks assumes you have the `haml`, `compass` and `compass-wordpress` gems installed.

## Install the Thor tasks:

    thor install http://github.com/adamstac/thor-wordpress/raw/master/wordpress.thor

## Install WordPress with Thor

Change directory to the directory you want to install WordPress in. You'll be asked if you want to install [Thematic](http://themeshaper.com/thematic/) and also Starkers. These instructions assume you say yes to Thematic.

    cd ~/Sites/mysite/
    thor wp:install

Change directory to the theme directory

    cd wp-content/themes/

Create your new theme directory

    mkdir mytheme
    cd mytheme/

Install your new theme with Thor. This assumes that you said yes to using installing Thematic and by default unpacks the Thematic project template located inside the Compass-WordPress gem.

    thor wp:install:theme
    
## Use rsync to deploy your theme

Generate deploy.yaml to your current directory using this command.

You'll be asked (in your terminal) for your `ssh_user` and `remote_root` details. Thor will then create your `deploy.yaml` file for you, populate it with your responses and then add it to your current directory.

    thor wp:deploy:generate_config
    
Once that's in place you can run this command to deploy your theme to your server.

    thor wp:deploy:theme

## Thor-WordPress tasks

    wp:install
    ----------
    wp:install:app [--directory=DIRECTORY] [--version=VERSION]
    # Download and unpack WordPress from the interwebs
 
    wp:install:theme --themename=<theme> --directory=<directory> [--directory=DIRECTORY] [--themename=THEMENAME]
    # Unpacks the specified <theme> from the compass-wordpress gem (Default task)
 
    wp:styles
    ---------
    wp:styles:generate
    # Clears and Generates the styles (Default task)
 
    wp:styles:clear
    # Clears the styles
 
    wp:styles:watch
    # Runs compass --watch
 
    wp:deploy
    ---------
    wp:deploy:theme
    # Deploys the theme (Default task)
 
    wp:deploy:app
    # Deploys the app
 
    wp:deploy:generate_config
    # Asks for ssh_user and remote_root, and generates the deploy.yaml file
    
## Contributors

[Adam Stacoviak](http://adamstacoviak.com/) and [Wynn Netherland](http://wynnnetherland.com/)
    
## License

See LICENSE
## Thor WordPress: A set of Thor tasks to make developing with WordPress easier

Before going ANY FURTHER. If you are going to use Thor-Wordpress it's not required, but suggested that you look `haml`, `compass` and `compass-wordpress`.

The [Compass-Wordpress](http://github.com/pengwynn/compass-wordpress) gem helps with creating and installing Wordpress themes using Sass and Compass.

## Install the Thor-Wordpress tasks:

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

Install your new theme with Thor. This assumes that you said yes to using installing Thematic and by default unpacks the Thematic project template located inside the [Compass-Wordpress](http://github.com/pengwynn/compass-wordpress) gem.

    thor wp:install:theme --theme=<theme>
    
## Use rsync to deploy your theme

To use rsync to deploy your Wordpress app or theme, you will need to generate a deploy config to your current directory.

Thor-Wordpress will create a `deploy.yaml` file for you in your current directory. You will need to update this Yaml file with the name of your theme and server details to enable rsync deployment.

    thor wp:generate:deploy_config
    
Once `deploy.yaml` is in place you can run this command to deploy your theme to your server.

    thor wp:deploy:theme

## Thor-WordPress tasks

    wp:install
    ----------
    wp:install:wordpress [--thematic] [--directory=DIRECTORY] [--thematic] [--version=VERSION]
    # Download and unpack WordPress from the interwebs (Default task)
 
    wp:install:theme --theme=<theme> --directory=<directory> [--directory=DIRECTORY] [--theme=THEME]
    # Unpacks the specified <theme> from the compass-wordpress gem
 
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
 
    wp:generate
    -----------
    wp:generate:deploy_config
    # Generates the deploy.yaml file
    
## Contributors

[Adam Stacoviak](http://adamstacoviak.com/) and [Wynn Netherland](http://wynnnetherland.com/)
    
## License

See LICENSE
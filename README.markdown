## Thor WordPress: A set of Thor tasks to make developing with WordPress easier

Before you go ANY FURTHER, using these Thor tasks assumes you have the `haml`, `compass` and `compass-wordpress` gems installed.

## Install the Thor tasks:

    thor install http://github.com/adamstac/thor-wordpress/raw/master/wordpress.thor
    thor install http://github.com/adamstac/thor-wordpress/raw/master/theme.thor

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

    thor theme:install
    
## Use rsync to deploy your theme

Update lines 4 and 7 of `deploy.thor` located in your theme directory to use rsync to deploy your theme.

## Thor-WordPress tasks

    wordpress
    ---------
    wordpress:install [--directory=DIRECTORY] [--version=VERSION]
    # Download and unpack WordPress from the interwebs

    theme
    -----
    theme:install --theme=<theme> [--directory=DIRECTORY] [--theme=THEME]
    # Unpacks the specified <theme> from the compass-wordpress gem

    theme:generate
    # Clears and Generates the styles

    theme:watch
    # Runs compass --watch

    theme:clear
    # Clears the styles

    deploy
    ------
    deploy:theme
    # Deploys the theme
    
## Contributors

[Adam Stacoviak](http://adamstacoviak.com/) and [Wynn Netherland](http://wynnnetherland.com/)
    
## License

See LICENSE
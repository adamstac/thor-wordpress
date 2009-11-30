class Theme < Thor
  
  desc "install --theme=<theme>", "Unpacks the specified <theme> from the compass-wordpress gem"
  method_options :directory => :string, :theme => :string
  def install
    opts = {'directory' => '.', 'theme' => 'thematic'}
    opts = opts.merge(options)

    puts "*** Installing Child Theme ***"
    cmd = "compass -r compass-wordpress -f wordpress --sass-dir=sass --css-dir=css -s compressed -p #{opts['theme']} #{opts['directory']}"
    system cmd
  end

  desc "generate", "Clears and Generates the styles"
  def generate
    invoke :clear
    puts "*** Generating styles ***"
    system "compass"
  end

  desc "watch", "Runs compass --watch"
  def watch
    system "compass --watch"
  end

  desc "clear", "Clears the styles"
  def clear
    puts "*** Clearing styles ***"
    system "rm -Rfv css/*"
  end

end
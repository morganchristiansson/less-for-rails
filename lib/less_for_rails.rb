require 'fileutils'
module LessForRails
  HEADER = %{/*
 This file was auto generated by Less (http://lesscss.org), using
 the less-for-rails plugin (http://github.com/augustl/less-for-rails).
 
 To change the contents of this file, edit %s.less instead.
*/

}
  extend self

  def paths
    @paths ||= ["#{Rails.root}/public/stylesheets"]
  end

  # Converts all public/stylesheets/*.less to public/stylesheets/*.css.
  #
  # Options:
  #  compress - Remove all newlines? `true` or `false`.
  def run(options = {})
    paths.map {|path| Dir["#{path}/*.less"]}.flatten.each do |source|
      destination_file = File.basename(source, File.extname(source))
      destination_directory = "#{Rails.root}/public/stylesheets"
      destination = "#{destination_directory}/#{destination_file}.css"
      
      if !File.exists?(destination) || File.stat(source).mtime > File.stat(destination).mtime
        engine = Less::Engine.new(File.read(source))
        css = Less.version > "1.0" ? engine.to_css : engine.to_css(:desc)
        css = css.delete("\n") if options[:compress]

        FileUtils.mkdir_p(destination_directory)
        File.open(destination_path, "w") {|file|
          file.write HEADER % [destination_file] if Rails.env == "development"
          file.write css
        }
      end
    }
  end
end
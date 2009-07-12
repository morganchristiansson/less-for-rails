module LessForRails
  STYLESHEET_PATHS = []
  STYLESHEET_PATHS << "#{Rails.root}/public/stylesheets"
  HEADER = %{/*
 This file was auto generated by Less (http://lesscss.org), using
 the less-for-rails plugin (http://github.com/augustl/less-for-rails).
 
 To change the contents of this file, edit %s.less instead.
*/

}
  extend self
  
  # Converts all public/stylesheets/*.less to public/stylesheets/*.css.
  #
  # Options:
  #  compress - Remove all newlines? `true` or `false`.
  def run(options = {})
    less_sheets = STYLESHEET_PATHS.map {|p| Dir["#{p}/*.less"] }.flatten
    less_sheets.each {|less|
      engine = Less::Engine.new(File.read(less))
      css = Less.version > "1.0" ? engine.to_css : engine.to_css(:desc)
      css = css.delete("\n") if options[:compress]
      
      destination_file = File.basename(less, File.extname(less))
      destination_path = "#{Rails.root}/public/stylesheets/#{destination_file}.css"
      
      File.open(destination_path, "w") {|file|
        file.write HEADER % [destination_file] if Rails.env == "development"
        file.write css
      }
    }
  end
end
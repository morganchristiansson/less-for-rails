begin
  config.gem "less"
  require 'less'
rescue LoadError
  puts "Please install the Less gem, `gem install less`."
end

if RAILS_ENV == "development"
  # Compile less on every request
  ActionController::Base.before_filter { LessForRails.run }
else
  # Compile less when the application loads
  config.after_initialize do
    LessForRails.run(:compress => true)
  end
end

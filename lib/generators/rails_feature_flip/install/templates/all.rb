# frozen_string_literal: true

# Load all features from config/features
Dir.entries('config/features').reject { |f| File.directory?(f) }.sort.each do |feature|
  next if feature == 'all.rb'

  require_relative feature.chomp('.rb')
rescue LoadError => e
  puts e.message
end
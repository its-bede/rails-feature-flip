# frozen_string_literal: true

# Load all features from config/features
features_dir = File.expand_path(__dir__)
Dir.entries(features_dir).reject { |f| File.directory?(f) }.sort.each do |feature|
  next if feature == 'all.rb'

  require_relative feature.chomp('.rb')
rescue LoadError => e
  puts e.message
end

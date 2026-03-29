# frozen_string_literal: true

namespace :features do
  desc 'List all registered features and their current values'
  task list: :environment do
    features = RailsFeatureFlip::Registry.all

    if features.empty?
      puts 'No features registered.'
      next
    end

    rows = features.map do |name, feature|
      enabled = feature.respond_to?(:enabled?) ? feature.enabled?.to_s : 'n/a'
      attrs = feature_attributes(feature)
      [name.to_s, feature.class.name, enabled, attrs]
    end

    print_feature_table(%w[Feature Class Enabled Attributes], rows)
  end
end

desc 'List all registered features (alias for features:list)'
task features: 'features:list'

def feature_attributes(feature)
  if feature.respond_to?(:attributes)
    feature.attributes.except('enabled').map { |k, v| "#{k}: #{v.inspect}" }.join(', ')
  else
    ivars = feature.instance_variables - [:@enabled]
    ivars.map { |ivar| "#{ivar.to_s.delete_prefix('@')}: #{feature.instance_variable_get(ivar).inspect}" }.join(', ')
  end
end

def print_feature_table(headers, rows)
  widths = column_widths(headers, rows)
  template = widths.map { |w| "%-#{w}s" }.join('  ')

  puts format(template, *headers)
  puts widths.map { |w| '-' * w }.join('  ')
  rows.each { |row| puts format(template, *row) }
end

def column_widths(headers, rows)
  headers.each_with_index.map do |header, i|
    [header.length, *rows.map { |r| r[i].to_s.length }].max
  end
end

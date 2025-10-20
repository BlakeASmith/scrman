# frozen_string_literal: true

require 'json'
require 'csv'
require 'yaml'

class Formatter
  SUPPORTED_FORMATS = %w[tsv json yml yaml csv].freeze

  def initialize(format = 'tsv')
    @format = format.downcase
    validate_format!
  end

  def format(data, headers = nil)
    case @format
    when 'json'
      format_json(data)
    when 'yml', 'yaml'
      format_yaml(data)
    when 'csv'
      format_csv(data, headers)
    when 'tsv'
      format_tsv(data, headers)
    else
      raise "Unsupported format: #{@format}"
    end
  end

  private

  def validate_format!
    unless SUPPORTED_FORMATS.include?(@format)
      raise "Unsupported format: #{@format}. Supported formats: #{SUPPORTED_FORMATS.join(', ')}"
    end
  end

  def format_json(data)
    JSON.pretty_generate(data)
  end

  def format_yaml(data)
    data.to_yaml
  end

  def format_csv(data, headers)
    return '' if data.empty?

    CSV.generate do |csv|
      if headers
        csv << headers
      elsif data.first.is_a?(Hash)
        csv << data.first.keys
      end
      
      data.each do |row|
        if row.is_a?(Hash)
          csv << row.values
        else
          csv << row
        end
      end
    end
  end

  def format_tsv(data, headers)
    return '' if data.empty?

    output = []
    
    if headers
      output << headers.join("\t")
    elsif data.first.is_a?(Hash)
      output << data.first.keys.join("\t")
    end
    
    data.each do |row|
      if row.is_a?(Hash)
        output << row.values.join("\t")
      else
        output << row.join("\t")
      end
    end
    
    output.join("\n")
  end
end
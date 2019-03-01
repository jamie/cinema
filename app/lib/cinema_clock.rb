# frozen_string_literal: true

require 'http'
require 'nokogiri'

module CinemaClock
  def self.films_at(url)
    doc = Nokogiri::HTML(HTTP.get(url).to_s)
    doc.css('.showtimeblock').map do |node|
      Film.new(node, doc).to_h
    end.compact
  end
end

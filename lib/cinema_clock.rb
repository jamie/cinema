require 'http'

class CinemaClock
  def initialize(url)
    @url = url
    @html = HTTP.get(url).to_s
  end

  def films
    []
  end

private
end

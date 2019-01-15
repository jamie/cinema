require 'cinema_clock'

class Api::V1::FilmsController < Api::V1::BaseController
  def index
    films = []
    if (url = params['source'])
      films = CinemaClock.new(url).films
    else
      # Stub
      films << {
        title:    'No Show',
        theatre:  'No Theatre',
        duration: 120,
        showings: [],
      }
    end
    render json: films.to_json
  end
end

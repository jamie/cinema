# frozen_string_literal: true

module Api
  module V1
    class FilmsController < Api::V1::BaseController
      def index
        films = []
        if (url = params['source'])
          films = CinemaClock.films_at(url)
        else
          # Stub
          films << {
            title: 'No Show',
            theatre: 'No Theatre',
            duration: 120,
            showings: []
          }
        end
        render json: films.to_json
      end
    end
  end
end

class Api::V1::FilmsController < Api::V1::BaseController
  def index
    films = []
    if (url = params['source'])

    else
      # Stub
      films << {
        title: "Bumblebee",
        theatre: 'Galaxy Nanaimo',
        duration: 113,
        times: [
          ['2d', '4:15'],
          ['3d', '7:10'],
          ['3d', '9:50'],
        ],
      }
    end
    render json: films.to_json
  end
end

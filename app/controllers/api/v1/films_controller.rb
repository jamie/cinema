class Api::V1::FilmsController < Api::V1::BaseController
  def index
    stub = {
      title: "Bumblebee",
      duration: 113,
      times2d: ['4:15'],
      times3d: ['7:10', '9:50'],
    }
    respond_with [stub]
  end
end

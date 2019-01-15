require 'spec_helper'
require 'cinema_clock'

describe CinemaClock do
  context "(Galaxy Nanaimo)", vcr: {cassette_name: 'galaxy'} do
    let(:url) { 'https://www.cinemaclock.com/theatres/galaxy-nanaimo' }
    let(:parser) { CinemaClock.new(url) }
    let(:films) { parser.films }

    describe '#films' do
      it { expect(films.size).to eq(9) }
    end

  end
end

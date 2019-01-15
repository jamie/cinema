require 'spec_helper'
require 'cinema_clock'

describe CinemaClock do
  context "(Galaxy Nanaimo)", vcr: {cassette_name: 'cinema_clock/galaxy'} do
    let(:url) { 'https://www.cinemaclock.com/theatres/galaxy-nanaimo' }
    let(:parser) { CinemaClock.new(url) }
    let(:films) { parser.films }

    describe '#films' do
      it { expect(films.size).to eq(10) }

      describe 'Bumblebee' do
        let(:film) { films[5] }

        it { expect(film['title']).to eq("Bumblebee") }
        it { expect(film['theatre']).to eq("Galaxy Nanaimo") }
        it { expect(film['times'].size).to eq(3)}
        it { expect(film['times'][0]).to eq({'format' => '2d', 'time' => '4:15'})}
      end
    end
  end
end

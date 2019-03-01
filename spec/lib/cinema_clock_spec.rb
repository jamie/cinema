# frozen_string_literal: true

require 'rails_helper'

describe CinemaClock do
  context '(Galaxy Nanaimo)', vcr: { cassette_name: 'cinema_clock/galaxy' } do
    let(:url) { 'https://www.cinemaclock.com/theatres/galaxy-nanaimo' }
    let(:films) { CinemaClock.films_at(url) }

    describe '#films' do
      it { expect(films.size).to eq(10) }

      describe 'Bumblebee' do
        let(:film) { films[5] }

        it { expect(film['title']).to eq('Bumblebee') }
        it { expect(film['theatre']).to eq('Galaxy Nanaimo') }
        it { expect(film['showings'].size).to eq(6) }
        it {
          expect(film['showings'][0]).to eq(
            'format' => '2d',
            'time' => '4:15',
            'd3_time' => { 'start' => '2019-01-14 16:15:00', 'stop' => '2019-01-14 18:08:00' }
          )
        }
      end
    end
  end

  context '(Double Features)', vcr: { cassette_name: 'cinema_clock/double-feature' } do
    let(:url) { 'https://www.cinemaclock.com/theatres/avalon' }
    let(:films) { CinemaClock.films_at(url) }

    describe '#films' do
      it { expect(films.size).to eq(10) }

      describe 'Superman + Superman' do
        let(:feature) { films[0] }
        # TODO
      end
    end
  end

  context '(Upcoming)', vcr: { cassette_name: 'cinema_clock/upcoming' } do
    let(:url) { 'https://www.cinemaclock.com/theatres/avalon' }
    let(:films) { CinemaClock.films_at(url) }

    describe '#films' do
      it { expect(films.size).to eq(10) }

      describe 'Dragon Ball Super: Broly' do
        let(:film) { films[9] } # 8, when double feature collapses
        # TODO
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

describe CinemaClock::Film do
  let(:doc) do
    Nokogiri::HTML(page)
  end
  let(:film) do
    doc.css('.showtimeblock').map do |node|
      CinemaClock::Film.new(node, doc).to_h
    end.compact[0]
  end
  let(:hash) do
    film.to_h
  end

  describe '#to_h' do
    context 'comprehensive' do
      let(:page) do
        <<-HTML
          <div class="showtimeblock movie  fil3d filexp filcc filad fil1110100  fil2d filexp filcc filad fil1110010 cin494">
            <div class="movieblock fi70438 genact genadv gensci efilm" id="efilm70438">
                <div class="smallposter" data-url="/movies/bumblebee-2018">
                    <div class="tagm tagm0" onclick="favMovie(70438);return false;"></div><img class="lazy" src="/images/posters/140x210.png" data-src="/images/posters/140x210/38/bumblebee-2018-poster.jpg" alt="Bumblebee"></div>
                <div class="moviedesc">
                    <a href="/movies/bumblebee-2018/reviews">
                        <div class="valex 49122 49123 50122 50123">7<span class="decimal">.6</span></div>
                        <div class="valmain 49122 49123 50122 50123">7<span class="decimal">.6</span></div>
                    </a>
                    <h3 class="movietitle"><a href="/movies/bumblebee-2018">Bumblebee <span class="rtUS">PG-13</span><span class="rtQC">G</span><span class="rtON">PG</span><span class="rtAB">PG</span><span class="rtBC">PG</span><span class="rtMB">PG</span><span class="rtNS">PG</span></a></h3>
                    <p class="moviegenre"> 1h53m &bull; Science-fiction <span class="avec">&bull; Hailee Steinfeld &amp; John Cena</span>
                        <!-- TL e -->&bull; </span>4th&nbsp;week
                        <!-- G:act:adv:sci: -->
                    </p><a class="button16 btntim aw70438" href="/movies/bumblebee-2018/showtimes">times<div class="butsub aw70438"><!-- CINEMAS --></div></a><a class="button16 btninf inne" href="/movies/bumblebee-2018">info</a><a class="button16 btnvid" href="/movies/bumblebee-2018/videos/211647">videos<span class="butsub">9</span></a><a class="button16 btnrev inne" href="/movies/bumblebee-2018/reviews">reviews<span class="butsub nrevex 49122 49123 50122 50123">132</span><span class="butsub nrevmain 49122 49123 50122 50123">131</span></a>
                    <!--RevSnip-->
                </div>
                <!--MoBl-->
            </div>
            <div class="filall  fil2d filexp filcc filad fil1110010">
                <p class="timesalso"> Full Recliner Seating
                    <!-- ALONOTREG -->(<span class="cce" title>CC</span> + <span class="dvse" title>AD</span>)
                    <!-- ALONOTREG -->
                </p>
                <p class="times"><u>Today <span style="font-size:0.9em;">(Jan 14)</span></u><i>4:15</i></p>
                <p class="timesother">
                    <s><u>Tue <span style="font-size:0.9em;">(Jan 15)</span></u><i>4:15</i></s>
                </p>
            </div>
            <div class="filall  fil3d filexp filcc filad fil1110100">
                <p class="timesalso"> Full Recliner Seating &amp; in 3D
                    <!-- ALONOTREG -->(<span class="cce" title>CC</span> + <span class="dvse" title>AD</span>)
                    <!-- ALONOTREG -->
                </p>
                <p class="times"><u>Today <span style="font-size:0.9em;">(Jan 14)</span></u><i>7:10&nbsp; 9:50</i></p>
                <p class="timesother">
                    <s><u>Tue <span style="font-size:0.9em;">(Jan 15)</span></u><i>7:10&nbsp; 9:50</i></s>
                </p>
            </div>
          </div>
        HTML
      end

      it { expect(hash['title']).to eq('Bumblebee') }
      it { expect(hash['theatre']).to eq('') }
      it { expect(hash['duration']).to eq(113) }
      it { expect(hash['showings'].size).to eq(6) }
    end
  end
end

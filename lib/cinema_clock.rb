require 'http'
require 'nokogiri'

class CinemaClock < Struct.new(:url)
  def films
    doc = Nokogiri::HTML(HTTP.get(url).to_s)
    doc.css('.showtimeblock').map do |node|
      Film.new(node, doc).to_h
    end.compact
  end

  # Small-ish complex example (multi-format, incl future dates)
  # <div class="showtimeblock movie  fil3d filexp filcc filad fil1110100  fil2d filexp filcc filad fil1110010 cin494">
  #   <div class="movieblock fi70438 genact genadv gensci efilm" id="efilm70438">
  #       <div class="smallposter" data-url="/movies/bumblebee-2018">
  #           <div class="tagm tagm0" onclick="favMovie(70438);return false;"></div><img class="lazy" src="/images/posters/140x210.png" data-src="/images/posters/140x210/38/bumblebee-2018-poster.jpg" alt="Bumblebee"></div>
  #       <div class="moviedesc">
  #           <a href="/movies/bumblebee-2018/reviews">
  #               <div class="valex 49122 49123 50122 50123">7<span class="decimal">.6</span></div>
  #               <div class="valmain 49122 49123 50122 50123">7<span class="decimal">.6</span></div>
  #           </a>
  #           <h3 class="movietitle"><a href="/movies/bumblebee-2018">Bumblebee <span class="rtUS">PG-13</span><span class="rtQC">G</span><span class="rtON">PG</span><span class="rtAB">PG</span><span class="rtBC">PG</span><span class="rtMB">PG</span><span class="rtNS">PG</span></a></h3>
  #           <p class="moviegenre"> 1h53m &bull; Science-fiction <span class="avec">&bull; Hailee Steinfeld &amp; John Cena</span>
  #               <!-- TL e -->&bull; </span>4th&nbsp;week
  #               <!-- G:act:adv:sci: -->
  #           </p><a class="button16 btntim aw70438" href="/movies/bumblebee-2018/showtimes">times<div class="butsub aw70438"><!-- CINEMAS --></div></a><a class="button16 btninf inne" href="/movies/bumblebee-2018">info</a><a class="button16 btnvid" href="/movies/bumblebee-2018/videos/211647">videos<span class="butsub">9</span></a><a class="button16 btnrev inne" href="/movies/bumblebee-2018/reviews">reviews<span class="butsub nrevex 49122 49123 50122 50123">132</span><span class="butsub nrevmain 49122 49123 50122 50123">131</span></a>
  #           <!--RevSnip-->
  #       </div>
  #       <!--MoBl-->
  #   </div>
  #   <div class="filall  fil2d filexp filcc filad fil1110010">
  #       <p class="timesalso"> Full Recliner Seating
  #           <!-- ALONOTREG -->(<span class="cce" title>CC</span> + <span class="dvse" title>AD</span>)
  #           <!-- ALONOTREG -->
  #       </p>
  #       <p class="times"><u>Today <span style="font-size:0.9em;">(Jan 14)</span></u><i>4:15</i></p>
  #       <p class="timesother">
  #           <s><u>Tue <span style="font-size:0.9em;">(Jan 15)</span></u><i>4:15</i></s>
  #       </p>
  #   </div>
  #   <div class="filall  fil3d filexp filcc filad fil1110100">
  #       <p class="timesalso"> Full Recliner Seating &amp; in 3D
  #           <!-- ALONOTREG -->(<span class="cce" title>CC</span> + <span class="dvse" title>AD</span>)
  #           <!-- ALONOTREG -->
  #       </p>
  #       <p class="times"><u>Today <span style="font-size:0.9em;">(Jan 14)</span></u><i>7:10&nbsp; 9:50</i></p>
  #       <p class="timesother">
  #           <s><u>Tue <span style="font-size:0.9em;">(Jan 15)</span></u><i>7:10&nbsp; 9:50</i></s>
  #       </p>
  #   </div>
  # </div>
  class Film < Struct.new(:node, :doc)
    def to_h
      return if title.nil?
      {
        'title'    => title,
        'theatre'  => theatre,
        'duration' => duration,
        'showings' => showings,
      }
    end

  private
    def title
      title_str = node.css('.movietitle').text
      return if title_str.empty?
      title_str.match(/(.*) (PG-13|PG|G|R)+/).captures[0]
    end

    def theatre
      doc.css('#h1titlein h1').text
    end

    def duration
      h, m = node.css('.moviegenre').text.match(/(\d+)h(\d+)m/).captures.map(&:to_i)
      h * 60 + m
    end

    def showings
      node.css('.filall').map do |filall|
        is_3d = filall.attributes['class'].value.include?('fil3d')
        filall.css('.times i').text.split(' ').map do |time|
          {
            'format' => is_3d ? '3d' : '2d',
            'time'   => time,
          }
        end
      end.flatten.sort_by(&:values)
    end
  end
end

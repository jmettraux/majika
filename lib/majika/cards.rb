
# lib/majika/cards.rb

$: << 'lib'


require 'majika/poems'

def make_illustration(f)

  svgs = Dir['web/images/choro/*.svg'].collect { |pa| pa.split('/', 2).last }

  f.puts("<div class='illustration'>")
  3.times do
    f.puts("<div class='piece'>")
    f.puts("<img src='#{svgs.sample}'>")
    f.puts("</div>")
  end
  f.puts("</div>")
end

def make_card(f)

  s = make_poem(highlight_one_word: true)

  f.puts("<div class='card'>")

  f.puts("<div class='poem'>")
  f.puts(s.split("\n").join("<br/>"))
  f.puts("</div>")

  make_illustration(f)

  f.puts("</div>")
end

File.open(
  #"web/cards_#{Time.now.strftime('%Y%m%d_%H%M%S')}.html", 'wb'
  "web/cards.html", 'wb'
) do |f|
  f.write(File.read('lib/majika/cards_head.html'))
  9.times { make_card(f) }
  f.write(File.read('lib/majika/cards_tail.html'))
end


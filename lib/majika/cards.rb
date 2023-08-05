
# lib/majika/cards.rb

$: << 'lib'


require 'majika/poems'

def make_text(f)

  s = make_poem(highlight_one_word: true)

  f.puts("<div class='poem'>")
  f.puts(s.split("\n").join("<br/>"))
  f.puts("</div>")
end

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

def make_cost(f)
end
def make_benefit(f)
end
def make_condition(f)
end
def make_product(f)
end

def make_head(f)

  f.puts("<div class='head'>")
    f.puts("<div class='west'>")
      make_cost(f)
    f.puts("</div>")
    f.puts("<div class='center'>")
    f.puts("</div>")
    f.puts("<div class='east'>")
      make_benefit(f)
    f.puts("</div>")
  f.puts("</div>")
end

def make_foot(f)

  f.puts("<div class='foot'>")
    f.puts("<div class='west'>")
      make_condition(f)
    f.puts("</div>")
    f.puts("<div class='center'>")
    f.puts("</div>")
    f.puts("<div class='east'>")
      make_product(f)
    f.puts("</div>")
  f.puts("</div>")
end

def make_card(f)

  f.puts("<div class='card'>")

  make_head(f)
  make_text(f)
  make_illustration(f)
  make_foot(f)

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


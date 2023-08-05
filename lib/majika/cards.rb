
# lib/majika/cards.rb

$: << 'lib'

IMGS = %w[
       bricks  light_block_brick.svg
        water  light_bridge_water.svg
         card  light_card_diamond.svg
         moon  light_moon.svg
        sword  light_sword.svg
         gate  light_torii_gate.svg
       updown  regular_arrow_down_arrow_up.svg
      arcdown  regular_arrow_down_to_arc.svg
        arcup  regular_arrow_up_from_arc.svg
         bolt  regular_bolt.svg
       circle  regular_circle.svg
        cloud  regular_cloud.svg
           d4  regular_dice_d4.svg
           d6  regular_dice_d6.svg
      droplet  regular_droplet.svg
         fire  regular_fire_flame_curved.svg
        heart  regular_heart.svg
      hexagon  regular_hexagon.svg
      octagon  regular_octagon.svg
    hourglass  regular_hourglass.svg
  octagonplus  regular_octagon_plus.svg
         play  regular_play.svg
    rectangle  regular_rectangle.svg
      diamond  regular_rhombus.svg
       shield  regular_shield.svg
        skull  regular_skull.svg
       square  regular_square.svg
         star  regular_star.svg
          sun  regular_sun_bright.svg
     triangle  regular_triangle.svg
        water  regular_water.svg
         wind  regular_wind.svg
      feather  sharp_regular_feather.svg
       person  solid_person.svg ]
    .each_slice(2)
    .inject({}) { |h, (k, fn)|
      h[k.to_sym] = "<img class='sym' src='#{File.join('images/fa', fn)}' />"
      h }

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

def do_roll(count, die, modifier=0, min, max)

  r = 0
  count.times { r = r + rand(die) + 1 }
  r += modifier

  r = min if r < min
  r = max if r > max

  r
end

def roll(s, min=-10_000, max=10_000)

  m = s.match(/^(\d*)d(\d+)([-+]\d+)?$/)

  mod =
    m[3] == '' ? 0 :
    m[3].start_with?('+') ? (m[3][1..-1]).to_i :
    -1 * (m[3][1..-1]).to_i

  do_roll(m[1].to_i, m[2].to_i, mod, min, max)
end

def make_cost(f)

  roll('2d5-5', 0).times { f.puts(IMGS[:heart]) }
  roll('2d6-5', 0).times { f.puts(IMGS[:droplet]) }
  #if (n = roll('2d6-5', 0)) > 0
  #  f.print("#{n} #{IMGS[:heart]}")
  #end
  #if (n = roll('2d6-5', 0)) > 0
  #  f.print("#{n} #{IMGS[:droplet]}")
  #end
end

def make_benefit(f)

  roll('1d10-9', 0).times { f.puts(IMGS[:gate]) }
end

def make_condition(f)
end

def make_product(f)

  roll('1d6-3', 0).times { f.puts(IMGS[:heart]) }
  roll('1d6-3', 0).times { f.puts(IMGS[:droplet]) }
  roll('1d6-3', 0).times { f.puts(IMGS[:bolt]) }
  roll('1d6-3', 0).times { f.puts(IMGS[:shield]) }
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

def make_card(f, i)

  k = ''
  k += ' east-row' if [ 2, 5, 8 ].include?(i)
  k += ' south-row' if [ 6, 7, 8 ].include?(i)

  f.puts("<div class='card#{k}'>")

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
  9.times { |i| make_card(f, i) }
  f.write(File.read('lib/majika/cards_tail.html'))
end



# lib/majika/cards.rb

require 'ostruct'

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

def make_text(k, f)

  s = make_poem(highlight_one_word: true)

  f.puts("<div class='poem'>")
  f.puts(s.split("\n").join("<br/>"))
  f.puts("</div>")
end

def make_illustration(k, f)

  svgs = Dir['web/images/choro/*.svg'].collect { |pa| pa.split('/', 2).last }

  mod = "+#{k.cost.level}"

  dmg = (
    [ '' ] + %w[ 1d1 1d4 1d6 1d8 2d4 1d10 1d12 2d6 3d4 1d20 3d6 2d10 ]
  )[k.product.level] || '2d20'

  dfc = roll('3d6+1', min: 5)

  f.puts("<div class='illustration'>")
    f.puts("<div class='modifier'>#{mod}</div>")
    f.puts("<div class='piece'><img src='#{svgs.sample}'></div>")
    f.puts("<div class='damage'>#{dmg}</div>")
    f.puts("<div class='piece'><img src='#{svgs.sample}'></div>")
    f.puts("<div class='defence'>#{dfc}</div>")
    f.puts("<div class='piece'><img src='#{svgs.sample}'></div>")
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

#def roll(s, min=-10_000, max=10_000)
def roll(s, opts={})

  m = s.match(/^(\d*)d(\d+)([-+]\d+)?$/)

  mod =
    m[3] == nil || m[3] == '' ? 0 :
    m[3].start_with?('+') ? (m[3][1..-1]).to_i :
    -1 * (m[3][1..-1]).to_i

  do_roll(
    m[1].to_i, m[2].to_i, mod,
    opts[:min] || -10_000, opts[:max] || 10_000)
end

def make_cost(k, f)

  k.cost.hearts.times { f.puts(IMGS[:heart]) }
  k.cost.droplets.times { f.puts(IMGS[:droplet]) }
end

def make_benefit(k, f)

  k.benefit.gates.times { f.puts(IMGS[:gate]) }
end

def make_condition(k, f)
end

def make_product(k, f)

  k.product.hearts.times { f.puts(IMGS[:heart]) }
  k.product.droplets.times { f.puts(IMGS[:droplet]) }
  k.product.bolts.times { f.puts(IMGS[:bolt]) }
  k.product.shields.times { f.puts(IMGS[:shield]) }
  k.product.persons.times { f.puts(IMGS[:person]) }
end

def make_head(k, f)

  f.puts("<div class='head'>")
    f.puts("<div class='west'>")
      make_cost(k, f)
    f.puts("</div>")
    f.puts("<div class='center'>")
    f.puts("</div>")
    f.puts("<div class='east'>")
      make_benefit(k, f)
    f.puts("</div>")
  f.puts("</div>")
end

def make_foot(k, f)

  f.puts("<div class='foot'>")
    f.puts("<div class='west'>")
      make_condition(k, f)
    f.puts("</div>")
    f.puts("<div class='center'>")
    f.puts("</div>")
    f.puts("<div class='east'>")
      make_product(k, f)
    f.puts("</div>")
  f.puts("</div>")
end

def make_card(f, i)

  k = OpenStruct.new
  k.cost = OpenStruct.new
  k.benefit = OpenStruct.new
  k.product = OpenStruct.new

  k.cost.hearts = roll('2d5-5', min: 0)
  k.cost.droplets = roll('2d6-5', min: 0)

  k.cost.level =
    %w[ hearts droplets ]
      .inject(0) { |r, n|
        mod = 1
        r + mod * k.cost[n] }

  k.benefit.gates = roll('1d10-9', min: 0)

  k.product.hearts = roll('1d6-3', min: 0)
  k.product.droplets = roll('1d6-3', min: 0)
  k.product.bolts = roll('1d6-3', min: 0)
  k.product.shields = roll('1d6-3', min: 0)
  k.product.persons = roll('1d6-5', min: 0, max: 1)

  k.product.level =
    %w[ hearts droplets bolts shields persons ]
      .inject(0) { |r, n|
        mod =
          n == 'persons' ? 4 :
          1
        r + mod * k.product[n] }

  c = ''
  c += ' east-row' if [ 2, 5, 8 ].include?(i)
  c += ' south-row' if [ 6, 7, 8 ].include?(i)

  f.puts("<div class='card#{c}'>")

  make_head(k, f)
  make_text(k, f)
  make_illustration(k, f)
  make_foot(k, f)

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


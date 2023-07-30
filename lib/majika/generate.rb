
# lib/majika/generate.rb

SITES = %w[
  hill
  hamlet
  village
  city
  mountain
  river
  beach
    ]

POEMS = Dir['var/poems/*.txt']
  .inject([]) { |a, path|
    a.concat(
      File.readlines(path)
        .collect(&:strip)
        .select { |l|
          l.length > 0 &&
          l[0, 1] != '#' &&
          l != '***' }) }
        .collect { |l| m = l.match(/^(.+)[,.;:]$/); m ? m[1] : l }
        .uniq

#pp POEMS
puts
pp POEMS.size

puts
puts POEMS.sample.downcase
puts POEMS.sample.downcase
puts POEMS.sample.downcase
puts


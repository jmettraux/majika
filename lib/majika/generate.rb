
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

def fetch_poem_line

  {
    /--/ => '—',
    #/^i / => 'I ',
  }
    .inject(POEMS.sample.downcase) { |l, (k, v)| l.gsub(k, v) }
end

def make_poem

  [ fetch_poem_line,
    fetch_poem_line,
    fetch_poem_line,
      ].join("\n")
end

#pp POEMS
puts
pp POEMS.size

puts
puts make_poem
puts


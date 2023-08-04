
# lib/majika/poems.rb

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
  .collect { |path|
    File.readlines(path) }
  .reject { |lines|
    lines[0, 7].find { |l| l.strip.match?(/\!+\s*SKIP\s*\!+/) } }
  .inject([]) { |a, lines|
    a.concat(
      lines
        .collect(&:strip)
        .select { |l|
          l.length > 0 &&
          l[0, 1] != '#' &&
          l != '***' }) }
        .collect { |l| m = l.match(/^(.+)[,.;:]$/); m ? m[1] : l }
        .uniq

STOPS = File.readlines('lib/majika/stop_words.txt')
  .collect { |l| l.strip.downcase }
  .select { |w| w.length > 0 && w[0, 1] != '#' }

def fetch_poem_line

  {
    /^--+/ => '',
    /-+-$/ => '',
    /--/ => '—',
    /^"+([^"]+)$/ => '\1',
    /^([^"]+)"+$/ => '\1',
    #/^i / => 'I ',
  }
    .inject(POEMS.sample.downcase) { |l, (k, v)| l.strip.gsub(k, v) }
end

def make_poem(opts={})

  s = [
    fetch_poem_line,
    fetch_poem_line,
    fetch_poem_line, ]
      .shuffle
      .join("\n")

  if opts[:highlight_one_word]

    words = (s.scan(/\b\w+\b/) - STOPS).select { |w| w.length > 2 }
    word = words.sample
    s = s.gsub(word, word.upcase)
  end

  s
end



lines = File.readlines(ARGV[0])
  .collect { |li| li.strip.downcase.gsub(/  /, ' ') }
  #.select { |l| l[0, 1] != '#' }
    # no, done later on...

while lines[0] == ''; lines.shift; end
pp lines[0, 10]

paras = lines
  .inject([ '' ]) { |a, li|
    if li == ''
      a << ''
    else
      a[-1] << ' ' << li
    end
    a }

%w[ . , ; : ? ].each do |punct|
  paras = paras
    .inject([]) { |a, para|
      gs = para.strip.split(punct)
      gs = gs[0..-2].collect { |g| g = g + punct } + [ gs.last ].compact
      a.concat(gs) }
end

puts paras


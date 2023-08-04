
# lib/majika/generate.rb

$: << 'lib'

require 'majika/poems'


#pp POEMS
puts
pp POEMS.size

puts
puts make_poem(highlight_one_size: true)
puts


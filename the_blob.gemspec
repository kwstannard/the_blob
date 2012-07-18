Gem::Specification.new do |s|
  s.name        = 'the-blob'
  s.version     = '0.0.1'
  s.date        = '2012-07-12'
  s.summary     = 'The blob provides hash-based instance handling.'
  s.description = 'The blob provides hash-based instance handling.'
  s.authors     = ['Kelly Stannard']
  s.email       = 'kwstannard@gmail.com'
  directories   = ['', '/handlers', '/the_blob']
  s.files       = directories.map{|d| Dir.glob("lib#{d}/*.rb")}.flatten
  s.homepage    = 'https://github.com/kwstannard/the_blob'
end

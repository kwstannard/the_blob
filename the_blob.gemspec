Gem::Specification.new do |s|
  s.name        = 'the-blob'
  s.version     = '0.0.21'
  s.date        = '2012-09-14'
  s.summary     = 'The blob provides hash-based instance handling.'
  s.description = <<-DESC
The blob is an instance handling interface that seperates ORM responsibilities from application instances.
This allows for fast and easy testing of your application by not needing to load ORM code in your business logic.
  DESC
  s.authors     = ['Kelly Stannard']
  s.email       = 'kwstannard@gmail.com'
  directories   = ['', '/handlers', '/persisters', '/the_blob']
  s.files       = directories.map{|d| Dir.glob("lib#{d}/*.rb")}.flatten
  s.homepage    = 'https://github.com/kwstannard/the_blob'
end

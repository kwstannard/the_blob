require File.expand_path 'lib/the_blob/instance.rb', '.'
class Dog < Struct.new(:name)
  include Instance
  instance_indices :dog_tag
end

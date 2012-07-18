require 'the_blob/instance.rb'

class Dog < Instance
  attr_accessor :name
  instance_indices :dog_tag
end

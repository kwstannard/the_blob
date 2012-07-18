require 'the_blob/instance.rb'

class User < Instance
  attr_accessor :password_hash, :password_salt, :locale
  instance_indices :email
end

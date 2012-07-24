require File.expand_path 'lib/the_blob/instance.rb', '.'
class User < Struct.new(:password_hash, :password_salt, :locale)
  include Instance
  instance_indices :email
end

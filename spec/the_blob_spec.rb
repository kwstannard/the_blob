require 'the_blob'
describe TheBlob do
  it 'can be included in a class' do
    Class.new.instance_eval { include TheBlob }
  end
end

require File.expand_path("../../../lib/the_blob/instance.rb", __FILE__)

describe Instance do
  let(:foo_class) { Class.new }
  let(:bar_class) { Class.new }
  let(:foo) { foo_class.new }
  let(:bar) { bar_class.new }

  before(:each) do
    foo_class.class_eval { include Instance }
    bar_class.class_eval { include Instance }
  end

  it "has an id field that starts at 1" do
    foo.id.should == 1
  end

  it "increments the id by one for each new instance" do
    foo_class.new
    foo.id.should == 2
  end

  it "uses different incrementers for different classes" do
    foo
    bar.id.should == 1
  end

  it "has a list of indices" do
    foo_class.class_eval{ instance_indices :email }
    foo_class.get_instance_indices.should == [:email, :id]
  end

  it "has different index lists for each instance" do
    bar_class.class_eval{ self.instance_indices :name_last }
    bar_class.get_instance_indices.should == [:name_last, :id]
  end

end

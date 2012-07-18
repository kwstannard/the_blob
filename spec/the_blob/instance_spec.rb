require File.expand_path("../../../lib/the_blob/instance.rb", __FILE__)

describe Instance do
  class Herp < Instance; end

  it "has an id field that starts at 1" do
    Herp.new.id.should == 1
  end

  it "increments the id by one for each new instance" do
    Herp.new
    Herp.new.id.should == 3
  end

  it "uses different incrementers for different classes" do
    class Derp < Instance; end
    Herp.new
    Derp.new.id.should == 1
  end

  it "has a list of indices" do
    class Herp < Instance; instance_indices :email; end
    Herp.get_instance_indices.should == [:email, :id]
  end

  it "has different index lists for each instance" do
    class Derp < Instance; instance_indices :name_last; end
    Derp.get_instance_indices.should == [:name_last, :id]
  end

end

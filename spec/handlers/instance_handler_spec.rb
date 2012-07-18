require 'handlers/instance_handler'

describe InstanceHandler do

  let(:subj_class) { Class.new }
  let(:subject) { subj_class.new }

  let(:user) { User.new(email: double) }
  let(:user2) { User.new(email: double) }
  let(:dog) { Dog.new(name: double, dog_tag: double) }

  before(:each) do
    subj_class.class_eval { include InstanceHandler }
  end

  it "requires all files in the instance folder" do
    subject.stub!(:create_methods)
    expect{ Dog }.to_not raise_error
    expect{ User }.to_not raise_error
  end

  it "can retrieve an instance via one of its indexes" do
    subject.absorb(user)
    subject.emit_user_by_email(user.email).should == user
    subject.emit_user_by_id(user.id).should == user
  end

  it 'raises InstanceNotFound if nothing is found' do
    error = subj_class::InstanceNotFound
    expect{ subject.emit_user_by_email(user.email) }.to raise_error(error)
  end

  it "can return a list of instances of a given class" do
    subject.absorb(user)
    subject.absorb(user2)
    subject.users.should == [user, user2]
  end

  #TODO make sure that inserting into subject.users does not affect the blob

end

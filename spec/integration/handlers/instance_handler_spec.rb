require 'handlers/instance_handler'

describe InstanceHandler do
  let(:subj_class) { Class.new }
  subject {subj_class.new}

  let(:user) { User.new(email: double) }
  let(:user2) { User.new(email: double) }
  let(:dog) { Dog.new(name: double, dog_tag: double) }

  before(:each) do
    subj_class.class_eval { include InstanceHandler }
  end

  it 'can absorb and return and instance' do
    subject.absorb user
    subject.emit_user_by_email(user.email).should eq user
  end

end

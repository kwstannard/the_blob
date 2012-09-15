require 'persisters/memory_persister'
require File.expand_path 'app/instances/user', '.'
require File.expand_path 'app/instances/dog', '.'
describe MemoryPersister::MemoryContainer do
  let(:subject) { MemoryPersister::MemoryContainer.new([User, Dog], capacity: 10) }

  let(:user) { User.new(email: double) }
  let(:user2) { User.new(email: double) }
  let(:dog) { Dog.new(name: double, dog_tag: double) }

  it "can retrieve an instance via one of its indexes" do
    subject.absorb(user)
    subject.emit_user_by_email(user.email).should eq user
    subject.emit_user_by_id(user.id).should eq user
  end

  context 'thread safe' do
    it 'passes dups out on emission' do
      subject.absorb user
      emission = subject.emit_user_by_email(user.email)
      emission.should_not be user
      emission.email.should eq user.email
    end
  end

  it 'raises InstanceNotFound if nothing is found' do
    error = TheBlob::InstanceNotFound
    expect{ subject.emit_user_by_email(user.email) }.to raise_error(error)
  end

  describe '#clear' do
    it 'removes all instances from the index hash' do
      subject.absorb user
      subject.clear
      error = TheBlob::InstanceNotFound
      expect{ subject.emit_user_by_email(user.email) }.to raise_error(error)
    end
    it 'resets its capacity left' do
      subject.absorb user
      subject.clear
      subject.capacity_left.should eq 10
    end
  end

  context 'capacity' do
    it 'has a maximum number of stored instances' do
      subject.capacity_left.should eq(10)
    end

    it 'should raise Full if it is at capacity' do
      error = MemoryPersister::Full
      expect{ 11.times{ subject.absorb User.new } }.to raise_error error
    end
  end
end

describe MemoryPersister do
  subject { MemoryPersister.new([User, Dog], capacity: 6) }
  it 'creates an emitter for each instances index' do
    expect{ subject.emit_user_by_email 'derp' }.to_not raise_error(NoMethodError)
    expect{ subject.emit_dog_by_dog_tag 'derp' }.to_not raise_error(NoMethodError)
  end
  it 'ensures old instances are deleted' do
    old_user = User.new email: double
    subject.absorb old_user
    subject.emit_user_by_email(old_user.email).should eq old_user

    6.times { subject.absorb User.new email: double }
    error = TheBlob::InstanceNotFound
    expect{ subject.emit_user_by_email(old_user.email) }.to raise_error(error)
  end
  it 'moves old instaces to new instances list if they are emitted' do
    old_user = User.new email: double
    subject.absorb old_user
    4.times { subject.absorb User.new email: double }
    subject.emit_user_by_email(old_user.email).should eq old_user
  end
#  it 'does not destroy your computer' do
#    subject = MemoryPersister.new([User], capacity: 10000)
#    100000.times { subject.absorb User.new email: double }
#  end
end

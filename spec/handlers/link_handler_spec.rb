require 'handlers/link_handler'

class Subj; include LinkHandler; end

describe LinkHandler do

  let(:subject) { Subj.new }
  let(:person) { double("bob", :class => "Person", :id => "id1") }
  let(:person2) { double("jim", :class => "Person", :id => "id2") }
  let(:herp) { double("herp", :class => "Herp", :id => "id1") }

  it "can return a list of linked instances of a given class" do
    subject.create_link(person, person2)
    subject.create_link(person, herp)
    subject.get_links(person, person2.class).should == [person2]
    subject.get_links(person, herp.class).should == [herp]
  end
end

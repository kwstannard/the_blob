module LinkHandler

  def create_link (instance_1, instance_2)
    links[instance_1][instance_2.class] << instance_2
    links[instance_2][instance_1.class] << instance_1
    nil
  end

  def delete_link(instance_1, instance_2)
    links[instance_1][instance_2.class].delete(instance_2)
    links[instance_2][instance_1.class].delete(instance_1)
    nil
  end

  def get_links(instance, klass)
    links[instance][klass].dup
  end

  private

  def links
    @links ||= Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = []} }
  end

end

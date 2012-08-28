class MemoryPersister

  class InstanceNotFound < RuntimeError; end
  class Full < RuntimeError; end

  def initialize(klass_list, options = {})
    klass_list.each{ |klass| make_index_getters(klass) }
    sub_capacity = (options[:capacity] || 100000) / 2
    @new_container = MemoryContainer.new klass_list, capacity: sub_capacity
    @old_container = MemoryContainer.new klass_list, capacity: sub_capacity
  end

  def absorb(instance)
    @new_container.absorb instance
  rescue MemoryPersister::Full
    rotate_containers
    absorb instance
  end

  private
  def rotate_containers
    @old_container.clear
    p = @new_container
    @new_container = @old_container
    @old_container = p
  end

  def make_index_getters(klass)
    klass.get_instance_indices.each do |index|
      instance_eval <<-CODE
        def emit_#{klass.underscore}_by_#{index}(id)
          @new_container.emit_#{klass.underscore}_by_#{index} id
        rescue MemoryPersister::InstanceNotFound
          instance = @old_container.emit_#{klass.underscore}_by_#{index} id
          @new_container.absorb instance
          instance
        end
      CODE
    end
  end

end

class MemoryPersister::MemoryContainer

  def initialize(klass_list, options = {})
    klass_list.each {|klass| make_index_getters klass }
    @capacity = options[:capacity] || 65535
    clear
  end

  def absorb(instance)
    raise MemoryPersister::Full if self.capacity_left <= 0
    klass = instance.class
    klass.get_instance_indices.each do |index|
      instances[klass.to_s]["__#{index}"][instance.send(index)] = instance
    end
    @capacity_used += 1
  end

  def capacity_left
    @capacity - @capacity_used
  end

  def clear
    @instances = new_instances_hash
    @capacity_used = 0
  end

  private

  def make_index_getters(klass)
    klass.get_instance_indices.each do |index|
      instance_eval <<-CODE
        def emit_#{klass.underscore}_by_#{index}(id)
          instance = instances["#{klass}"]["__#{index}"][id]
          instance && instance.dup || raise(MemoryPersister::InstanceNotFound)
        end
      CODE
    end
  end

  def instances
    @instances
  end

  def new_instances_hash
    hash = proc{|a| Hash.new{|hash, key| hash[key] = a} }
    hash.call( hash.call( hash.call( nil )))
  end

end

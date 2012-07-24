class MemoryPersister

  class InstanceNotFound < RuntimeError; end
  class Full < RuntimeError; end

  def initialize(klass_list, options = {})
    klass_list.each{ |klass| make_index_getters(klass) }
    sub_capacity = (options[:capacity] || 100000) / 2
    @new_persister = MemoryContainer.new klass_list, capacity: sub_capacity
    @old_persister = MemoryContainer.new klass_list, capacity: sub_capacity
  end

  def absorb(instance)
    @new_persister.absorb instance
  rescue MemoryPersister::Full
    rotate_persisters
    absorb instance
  end

  private
  def rotate_persisters
    @old_persister.clear
    p = @new_persister
    @new_persister = @old_persister
    @old_persister = p
  end

  def make_index_getters(klass)
    klass.get_instance_indices.each do |index|
      instance_eval <<-CODE
        def emit_#{klass.underscore}_by_#{index}(id)
          @new_persister.emit_#{klass.underscore}_by_#{index} id
        rescue MemoryPersister::InstanceNotFound
          instance = @new_persister.emit_#{klass.underscore}_by_#{index} id
          @new_persister.absorb instance
          user
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
          instance || raise(MemoryPersister::InstanceNotFound)
        end
      CODE
    end
  end

  def instances
    @instances ||= new_instances_hash
  end

  def new_instances_hash
    hash = proc{|a| Hash.new{|hash, key| hash[key] = a} }
    hash.call( hash.call( hash.call( nil )))
  end

end

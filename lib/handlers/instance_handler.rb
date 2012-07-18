require File.expand_path '../../the_blob/instance', __FILE__

module InstanceHandler

  class InstanceNotFound < RuntimeError; end

  module ClassMethods

    #TODO move this into seperate class
    def load_instances
      dir = File.expand_path("app/instances", ".")
      Dir["#{dir}/*"].each do |file|
        require file
        create_methods(file)
      end
    end

    def create_methods(file)
      klass = file.scan(/\/([^\/]+)\.rb/).first.first
      make_class_getter(klass)
      make_index_getters(klass)
    end

    def make_class_getter(klass)
      class_eval <<-CODE
        def #{klass}s
          instance_lists["#{klass.capitalize}"]
        end
      CODE
    end

    def make_index_getters(klass)
      Module.const_get(klass.capitalize).get_instance_indices.each do |index|
        class_eval <<-CODE
          def emit_#{klass}_by_#{index}(id)
            instance = instances["#{klass.capitalize}"]["__#{index}"][id]
            instance || raise(InstanceNotFound)
          end
        CODE
      end
    end

  end

  def self.included(base)
    base.extend(ClassMethods)
    base.load_instances
  end

  def absorb(instance)
    klass = instance.class
    instance_lists[klass.to_s] << instance
    klass.get_instance_indices.each do |index|
      instances[klass.to_s]["__#{index}"][instance.send(index)] = instance
    end
  end

  private

  def instances
    hash = proc{|a| Hash.new{|hash, key| hash[key] = a} }
    @instances ||= hash.call( hash.call( hash.call( nil )))
  end

  def instance_lists
    @instance_lists ||= Hash.new{|hash, key| hash[key] = Array.new }
  end

end

require File.expand_path '../../the_blob/instance', __FILE__

module InstanceHandler

  def initialize(options = {})
    load_instances
    @memory_persister = options[:memory].new(@klass_list)
  end

  def absorb(instance)
    @memory_persister.absorb instance
  end

  private
  def load_instances
    dir = File.expand_path("app/instances", ".")
    Dir["#{dir}/*"].each do |file|
      require file
      klass = Module.const_get file.scan(/\/([^\/]+)\.rb/).first.first.capitalize
      make_index_getters(klass)
      (@klass_list ||= []) << klass
    end
  end

  def make_index_getters(klass)
    klass.get_instance_indices.each do |index|
      instance_eval <<-CODE
        def emit_#{klass.underscore}_by_#{index}(id)
          @memory_persister.emit_#{klass.underscore}_by_#{index}(id)
        end
      CODE
    end
  end
end

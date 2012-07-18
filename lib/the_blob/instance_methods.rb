module InstanceMethods

  def self.included(base)
    base.instance_eval do
      def self.get_next_id
        @next_id ||= 0
        @next_id += 1
      end

      def self.instance_indices(*ind)
        indices = ind << :id
        attr_accessor *indices 
        @instance_indices = indices
      end

      def self.get_instance_indices
        @instance_indices ||= []
      end
    end
  end

  def initialize(attrs = {})
    @id = self.class.get_next_id
    attrs.each{ |name, value| name.inspect; send("#{name}=", value) }
  end

  def id
    @id
  end

end

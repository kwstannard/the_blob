require File.expand_path '../handlers/instance_handler', __FILE__
require File.expand_path '../persisters/memory_persister', __FILE__

module TheBlob

  class InstanceNotFound < RuntimeError; end

  def self.included(base)
    base.class_eval do
      include InstanceHandler
    end
  end

end

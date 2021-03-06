module Contracts
  module Core
    def self.included(base)
      common(base)
    end

    def self.extended(base)
      common(base)
    end

    def self.common(base)
      return if base.respond_to?(:Contract)

      base.extend(MethodDecorators)

      base.instance_eval do
        def functype(funcname)
          contracts = Engine.fetch_from(self).decorated_methods_for(:class_methods, funcname)
          if contracts.nil?
            "No contract for #{self}.#{funcname}"
          else
            "#{funcname} :: #{contracts[0]}"
          end
        end
      end

      base.class_eval do
        # TODO: deprecate
        # Required when contracts are included in global scope
        def Contract(*args)
          self.class.Contract(*args)
        end

        def functype(funcname)
          contracts = Engine.fetch_from(self.class).decorated_methods_for(:instance_methods, funcname)
          if contracts.nil?
            "No contract for #{self.class}.#{funcname}"
          else
            "#{funcname} :: #{contracts[0]}"
          end
        end
      end
    end
  end
end

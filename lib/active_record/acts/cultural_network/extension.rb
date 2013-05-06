module ActiveRecord
  module Acts
    module CulturalNetwork
      module Extension
        extend ActiveSupport::Concern

        included do
        end

        module ClassMethods
          def acts_as_cultural_network(options={})
            class_eval do
              #include ActiveRecord::Acts::CulturalNetworks::InstanceMethods
              
            end
            
          end
        end
        
        module InstanceMethods
          
        end
      end
    end
  end
end
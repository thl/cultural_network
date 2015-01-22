module KmapsEngine
  module Extensions
    module PublicControllerDependencies
      extend ActiveSupport::Concern
      
      included do
        before_action :set_common_variables
      end
    end
  end
end
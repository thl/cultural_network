class Admin::XMLDocumentsController < AclController
  resource_controller
  
  def initialize
    super
    @guest_perms = []
  end
end
class Admin::CaptionsController < AclController
  resource_controller
  
  belongs_to :feature
  
  new_action.before do
    used_languages = parent_object.captions.collect(&:language_id)
    english = Language.get_by_code('eng')
    query = Language.order('name')
    @languages = used_languages.empty? ? query : query.where(['id NOT IN (?)', used_languages])
    object.language = english if !used_languages.include? english.id
    @authors = AuthenticatedSystem::Person.order('fullname')
    object.author = current_user.person
  end
  
  edit.before do
    @languages = Language.order('name')
    @authors = AuthenticatedSystem::Person.order('fullname')
  end
  
  update.before do
    @languages = Language.order('name')
    @authors = AuthenticatedSystem::Person.order('fullname')
  end
  
  def parent_association
    @parent_object ||= parent_object
    @parent_object.captions
  end
end

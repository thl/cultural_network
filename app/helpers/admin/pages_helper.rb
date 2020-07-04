module Admin::PagesHelper
  def stacked_parents
    array = [:admin]
    if !parent_object.instance_of?(Feature) && parent_object.respond_to?(:feature)
      array << parent_object.feature
    end
    array << parent_object
    array
  end
end
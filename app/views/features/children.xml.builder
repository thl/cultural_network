xml.features do
  xml << render(:partial => 'stripped_feature.xml.builder', :collection => @features, :as => :feature) if !@features.empty?
end
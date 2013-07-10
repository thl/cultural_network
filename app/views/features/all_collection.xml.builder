xml.features(:type => 'array') do
  xml << render(:partial => 'recursive_stripped_feature.xml.builder', :collection => @features, :as => :feature) if !@features.empty?
end

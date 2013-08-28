# The following is performed because the name expression returns nil for Feature.find(15512)
name = feature.prioritized_name(@view)
header = name.nil? ? feature.pid : name.name
children = feature.children
options = { :id => feature.fid, :childCount => children.size, :title => header }
xml.feature(options) do
  xml << render(:partial => 'recursive_nested_feature.xml.builder', :collection => children, :as => :feature) if !children.empty?
end

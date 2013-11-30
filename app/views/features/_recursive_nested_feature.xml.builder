name = feature.prioritized_name(@view)
# The following is performed because the name expression returns nil for Feature.find(15512)
header = name.nil? ? feature.pid : name.name
children = feature.children.sort{|a,b| a.prioritized_name(@view) <=> b.prioritized_name(@view)}
captions = feature.captions
options = { :id => feature.fid, :childCount => children.size, :title => header }
xml.feature(options) do
  xml.features(:type => 'array') do
    xml << render(:partial => 'recursive_nested_feature.xml.builder', :collection => children, :as => :feature) if !children.empty?
  end
  xml.captions(:type => 'array') do
    xml << render(:partial => 'caption.xml.builder', :collection => captions) if !captions.empty?
  end
end

# The following is performed because the name expression returns nil for Feature.find(15512)
name = feature.prioritized_name(@view)
header = name.nil? ? feature.pid : name.name
children = feature.children
options = { :id => feature.fid, :db_id => feature.fid, :header => header }
if children.empty?
  xml.feature(options)
else
  xml.feature(options) do # , :pid => feature.pid
    xml.features(:type => 'array') do
      xml << render(:partial => 'recursive_stripped_feature.xml.builder', :collection => children, :as => :feature) if !children.empty?
    end
  end
end
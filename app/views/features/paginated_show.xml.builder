xml.instruct!
xml.features(:type => 'array', :page => params[:page] || 1, :total_pages => @features.total_pages) do
  xml << render(:partial => 'features/stripped_feature.xml.builder', :collection => @features, :as => :feature) if !@features.empty?
end
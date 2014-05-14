p = Perspective.get_by_code(default_perspective_code)
v = View.get_by_code(default_view_code)
@features = Feature.current_roots(p, v).sort_by{ |f| f.prioritized_name(v).name }
xml.instruct!
xml.features(:type => 'array') do
  xml << render(:partial => 'features/feature.xml.builder', :collection => @features) if !@features.empty?
end
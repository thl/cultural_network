@features = Feature.current_roots(Perspective.get_by_code(default_perspective_code), View.get_by_code('roman.popular'))
xml.instruct!
xml.features(:type => 'array') do
  xml << render(:partial => 'features/feature.xml.builder', :collection => @features) if !@features.empty?
end
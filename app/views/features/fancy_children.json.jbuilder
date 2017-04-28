json.array! @feature.all_child_relations do |c|
  json.title "<strong>#{c.child_node.prioritized_name(@view).name}</strong> (from #{c.perspective.name})"
  json.href feature_path(c.child_node.fid)
  json.lazy true
  json.key c.child_node.fid
end

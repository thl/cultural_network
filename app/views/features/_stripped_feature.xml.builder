# The following is performed because the name expression returns nil for Feature.find(15512)
name = feature.prioritized_name(@view)
header = name.nil? ? feature.pid : name.name
xml.feature(id: feature.fid, db_id: feature.id, header: header) { xml << render(partial: 'relation.xml.builder', object: relation) if defined? relation }
xml.feature_geo_code do
  xml.created_at(geo_code.created_at, :type => 'datetime')
  xml.updated_at(geo_code.updated_at, :type => 'datetime')
  xml.id(geo_code.id, :type => 'integer')
  xml.geo_code_value(geo_code.geo_code_value, :type => 'integer')
  code_type = geo_code.geo_code_type
  xml.geo_code_type do
    xml.id(code_type.id, :type => 'integer')
    xml.name(code_type.name)
    xml.code(code_type.code)
  end if !code_type.nil?
  xml << render(partial: 'time_units/index.xml.builder', locals: {time_units: geo_code.time_units})
end
attrs = { id: geo_code.id, value: geo_code.geo_code_value}
code_type = geo_code.geo_code_type
attrs[:code_type] = code_type.code if !code_type.nil?
xml.code(attrs)
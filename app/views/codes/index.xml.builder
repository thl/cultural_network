xml.feature do
  xml.old_pid(@feature.old_pid)
  xml.fid(@feature.fid, :type => 'integer')
  xml.geo_codes(:type => 'array') do
    @geo_codes.each do |geo_code|
      xml << render(:partial => 'geo_code.xml.builder', :collection => @geocodes) if !@geocodes.empty?
    end
  end
end
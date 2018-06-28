class Search
  include ActiveModel::Model
  @@keys = [:filter, :scope, :match, :search_scope, :has_descriptions, :context_id, :fid]
  @@keys.each{|k| attr_accessor k }  

  def self.defaults
    self.new(filter: '', scope: 'name', match: 'contains', search_scope: 'global', has_descriptions: '0', context_id: '', fid: '')
  end
  
  def to_h
    h = {}
    @@keys.each do |k| 
      val = self.send(k)
      h[k] = val if !val.blank?
    end
    h
  end
end

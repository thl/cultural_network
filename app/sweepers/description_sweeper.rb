class DescriptionSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Description
  FORMATS = ['xml', 'json']
  
  def after_save(record)
    expire_cache(record)
  end
  
  def after_destroy(record)
    expire_cache(record)
  end
  
  def expire_cache(description)
    feature = description.feature
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_full_path_page feature_description_url(feature.fid, description, options)
      expire_full_path_page feature_descriptions_url(feature.fid, options)
      expire_full_path_page feature_url(feature.fid, options)
    end
    feature.index!
  end
end
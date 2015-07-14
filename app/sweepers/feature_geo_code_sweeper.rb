class FeatureGeoCodeSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe FeatureGeoCode
  FORMATS = ['xml', 'json']
  
  def after_save(record)
    expire_cache(record)
  end
  
  def after_destroy(record)
    expire_cache(record)
  end
  
  def expire_cache(geo_code)
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_full_path_page feature_codes_url(geo_code.feature.fid, options)
    end
  end
end
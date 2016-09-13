class CaptionSweeper < ActionController::Caching::Sweeper
  include InterfaceUtils::Extensions::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  
  observe Caption
  FORMATS = ['xml', 'json']
  
  def after_save(record)
    expire_cache(record)
  end
  
  def after_destroy(record)
    expire_cache(record)
  end
  
  def expire_cache(caption)
    feature = caption.feature
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_full_path_page feature_url(feature.fid, options)
      expire_full_path_page feature_caption_url(feature.fid, caption, options)
      expire_full_path_page feature_captions_url(feature.fid, options)
    end
    feature.update_solr!
  end
end
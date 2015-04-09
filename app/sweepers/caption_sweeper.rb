class CaptionSweeper < ActionController::Caching::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  include InterfaceUtils::Extensions::Sweeper
  
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
      expire_page feature_url(feature.fid, options)
      expire_page feature_caption_url(feature.fid, caption, options)
      expire_page feature_captions_url(feature.fid, options)
    end
  end
end
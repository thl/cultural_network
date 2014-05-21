class CaptionSweeper < ActionController::Caching::Sweeper
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
      expire_page caption_url(caption, options)
      expire_page captions_url(options)
    end
  end
end
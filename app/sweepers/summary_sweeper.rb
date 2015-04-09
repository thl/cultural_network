class SummarySweeper < ActionController::Caching::Sweeper
  include Rails.application.routes.url_helpers
  include ActionController::Caching::Pages
  include InterfaceUtils::Extensions::Sweeper
  
  observe Summary
  FORMATS = ['xml', 'json']
  
  def after_save(record)
    expire_cache(record)
  end
  
  def after_destroy(record)
    expire_cache(record)
  end
  
  def expire_cache(summary)
    feature = summary.feature
    options = {:only_path => true}
    FORMATS.each do |format|
      options[:format] = format
      expire_page feature_url(feature.fid, options)
      expire_page feature_summary_url(feature.fid, summary, options)
      expire_page feature_summaries_url(feature.fid, options)
    end
  end
end
Rails.application.config.to_prepare do
  observers = [FeatureSweeper, FeatureRelationSweeper, SummarySweeper, PerspectiveSweeper, ViewSweeper]
  Rails.application.config.active_record.observers ||= []
  Rails.application.config.active_record.observers += observers
  observers.each { |o| o.instance }
end
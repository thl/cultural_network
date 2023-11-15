xml.instruct!
xml.features(type: 'array', page: params[:page] || 1, total_pages: @features.total_pages) do
  xml << render(partial: 'features/stripped_feature', format: 'xml', collection: @features, as: :feature) if !@features.empty?
end
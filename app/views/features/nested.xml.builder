xml.instruct!
xml << render(partial: 'recursive_nested_feature', format: 'xml', locals: {feature: @feature})
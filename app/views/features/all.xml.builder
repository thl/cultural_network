xml.instruct!
xml << render(partial: 'recursive_stripped_feature', format: 'xml', locals: {feature: @feature})
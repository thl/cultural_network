xml.instruct!
xml << render(partial: 'index', format: 'xml', locals: { names: @names })
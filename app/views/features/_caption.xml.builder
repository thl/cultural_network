tags = { :id => caption.id }
tags[:language] = caption.language.code if !caption.language.nil?
author = caption.author
xml.caption(tags) do
  xml.content(caption.content)
  xml.author(:id => author.id, :fullname => author.fullname) if !author.nil?
end
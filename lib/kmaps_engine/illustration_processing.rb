module KmapsEngine
  module IllustrationProcessing
    def self.do_convert_mms_to_mandala
      illustrations = Illustration.where(picture_type: 'MmsIntegration::Picture').all
      illustrations.each do |i|
        image = ShantiIntegration::Image.from_mms(i.picture_id)
        next if image.nil?
        if image.instance_of? Integer
          next
          attrs = { picture_id: image, picture_type: 'ShantiIntegration::Image' }
        else
          attrs = { picture_id: image.id, picture_type: 'ShantiIntegration::Image' }
        end
        i.update_attributes(attrs)
      end
    end
    
    def self.do_convert_external_to_mandala
      illustrations = Illustration.where(picture_type: 'ExternalPicture').all
      illustrations.each do |i|
        p = i.picture
        next if !p.shanti_image?
        image = p.shanti_image
        next if image.nil?
        if image.instance_of? Integer
          next
          attrs = { picture_id: image, picture_type: 'ShantiIntegration::Image' }
        else
          attrs = { picture_id: image.id, picture_type: 'ShantiIntegration::Image' }
        end
        i.update_attributes(attrs)
      end
    end
  end
end
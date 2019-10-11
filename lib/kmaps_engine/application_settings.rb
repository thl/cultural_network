module KmapsEngine
  module ApplicationSettings
    def self.homepage_blurb
      blurb_code = Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/homepage_blurb_code", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['homepage.intro.blurb.code']
        str = nil if str.blank?
        str
      end
      Blurb.find_by(code: (blurb_code.blank? ? 'homepage.intro' : blurb_code))
    end
    
    def self.default_perspective_code
      Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/default_perspective_code", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['default.perspective.code']
        str = nil if str.blank?
        str
      end
    end
    
    def self.default_view_code
      Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/default_view_code", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['default.view.code']
        str = nil if str.blank?
        str
      end
    end

    def self.default_relation_type_code
      Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/default_relation_type", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['default.relation_type.code']
        str = nil if str.blank?
        str
      end
    end

    def self.disable_cache_expiration?
      Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/disable_cache_expiration", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['disable.cache.expiration']
        str = '' if str.blank?
        return str.downcase == 'yes'
      end
    end
  end
end

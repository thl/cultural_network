module KmapsEngine
  module ApplicationSettings
    def self.homepage_blurb
      blurb_code = Rails.cache.fetch("application_settings/#{InterfaceUtils::Server.get_domain}/homepage_blurb_code", :expires_in => 1.day) do
        str = InterfaceUtils::ApplicationSettings.settings['homepage.intro.blurb.code']
        str = nil if str.blank?
        str
      end
      Blurb.where(code: (blurb_code.blank? ? 'homepage.intro' : blurb_code)).first
    end
  end
end
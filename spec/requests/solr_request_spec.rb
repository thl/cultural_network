require 'rails_helper'

RSpec.describe "Solrs", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/solr/show"
      expect(response).to have_http_status(:success)
    end
  end

end

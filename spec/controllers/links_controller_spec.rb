require 'rails_helper'

describe LinksController, type: :controller do
  include_context 'controller_setup'

  describe '#update' do
    first_url = Faker::Internet.url
    let(:link) { create(:link, url: first_url) }

    before do
      sign_in(user)
    end

    it 'updates the specified link' do
      second_url = Faker::Internet.url

      expect do
        put :update, params: { id: link.id, url: second_url }
        link.reload
      end.to change(link, :url).from(first_url).to(second_url)
    end

    it 'redirects to the updated territory group show page' do
      put :update, params: { id: link.id, url: second_url }
      expect(response).to redirect_to(polymorphic_path(link))
    end
  end
end

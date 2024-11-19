require 'rails_helper'

RSpec.describe StorageAssetSession, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:storage_asset_session) }

    it { is_expected.to validate_presence_of(:setting) }
    it { is_expected.to validate_uniqueness_of(:setting) }
    it { is_expected.to validate_presence_of(:value) }

    it 'validates presence of expires_at if setting is an expirable setting' do
      session = StorageAssetSession.new(setting: StorageAssetSession::EXPIRABLE_SETTINGS.first, value: 'access_token_value')

      expect(session).to_not be_valid
      expect(session.errors[:expires_at]).to include("can't be blank")

      session.expires_at = 4.hours.from_now
      expect(session).to be_valid
    end
  end

  describe '.dropbox_cursor' do
    context 'when dropbox_cursor setting exists' do
      let!(:cursor) { FactoryBot.create(:storage_asset_session, setting: StorageAssetSession::DROPBOX_CURSOR, value: 'cursor_value') }

      it 'does not call the StorageAssetService::Dropbox::GetLatestCursor service if the setting exists' do
        expect(StorageAssetService::Dropbox::GetLatestCursor).to_not receive(:new)
        StorageAssetSession.dropbox_cursor
      end

      it 'returns the record with the setting of dropbox_cursor if it exists' do
        expect(StorageAssetSession.dropbox_cursor).to eq(cursor)
      end
    end

    context 'when dropbox_cursor setting does not exist' do
      let(:cursor_double) { instance_double(StorageAssetService::Dropbox::GetLatestCursor, call: 'latest_cursor') }

      before do
        allow(StorageAssetService::Dropbox::GetLatestCursor).to receive(:new).and_return(cursor_double)
      end

      it 'calls the StorageAssetService::Dropbox::GetLatestCursor service and creates a new setting if it does not exist' do
        expect(StorageAssetService::Dropbox::GetLatestCursor).to receive(:new).and_return(cursor_double)

        expect do
          StorageAssetSession.dropbox_cursor
        end.to change(StorageAssetSession, :count).by(1)

        session = StorageAssetSession.last
        expect(session.setting).to eq(StorageAssetSession::DROPBOX_CURSOR)
        expect(session.value).to eq('latest_cursor')
      end

      it 'returns the newly created record' do
        session = StorageAssetSession.dropbox_cursor
        expect(session).to eq(StorageAssetSession.last)
      end
    end
  end

  describe '.dropbox_access_token' do
    context 'when dropbox_access_token setting exists' do
      let!(:access_token) { FactoryBot.create(:storage_asset_session, :dropbox_access_token) }

      it 'does not call the StorageAssetService::Dropbox::Oauth2Token service if the setting exists' do
        expect(StorageAssetService::Dropbox::Oauth2Token).to_not receive(:new)
        StorageAssetSession.dropbox_access_token
      end

      it 'returns the record with the setting of dropbox_access_token if it exists' do
        expect(StorageAssetSession.dropbox_access_token).to eq(access_token)
      end
    end

    context 'when dropbox_access_token setting does not exist or is expired' do
      let(:token_double) { instance_double(StorageAssetService::Dropbox::Oauth2Token, call: { access_token: 'latest_token', expires_in: 14_400 }) }

      before do
        allow(StorageAssetService::Dropbox::Oauth2Token).to receive(:new).and_return(token_double)
      end

      around do |example|
        freeze_time { example.run }
      end

      it 'calls the StorageAssetService::Dropbox::Oauth2Token service and creates a new setting if it does not exist' do
        expect(StorageAssetService::Dropbox::Oauth2Token).to receive(:new).and_return(token_double)

        expect do
          StorageAssetSession.dropbox_access_token
        end.to change(StorageAssetSession, :count).by(1)

        session = StorageAssetSession.last
        expect(session.setting).to eq(StorageAssetSession::DROPBOX_ACCESS_TOKEN)
        expect(session.value).to eq('latest_token')
        expect(session.expires_at).to eq(14_400.seconds.from_now)
      end

      it 'calls the StorageAssetService::Dropbox::Oauth2Token service and updates an existing token if the setting has expired' do
        access_token = FactoryBot.create(:storage_asset_session, :dropbox_access_token, expires_at: 1.hour.ago)

        expect(StorageAssetService::Dropbox::Oauth2Token).to receive(:new).and_return(token_double)

        expect do
          StorageAssetSession.dropbox_access_token
        end.to_not change(StorageAssetSession, :count)

        access_token.reload
        expect(access_token.value).to eq('latest_token')
        expect(access_token.expires_at).to eq(14_400.seconds.from_now)
      end

      it 'returns the newly created record when created' do
        session = StorageAssetSession.dropbox_access_token
        expect(session).to eq(StorageAssetSession.last)
      end

      it 'returns the newly created record when updated' do
        access_token = FactoryBot.create(:storage_asset_session, :dropbox_access_token, expires_at: 1.hour.ago)
        session = StorageAssetSession.dropbox_access_token
        expect(session).to eq(access_token)
      end
    end
  end

  describe '.microsoft_graph_token' do
    context 'when microsoft_graph_token setting exists' do
      let!(:access_token) { FactoryBot.create(:storage_asset_session, :microsoft_graph_token) }

      it 'does not call the StorageAssetService::MicrosoftGraph::Oauth2Token service if the setting exists' do
        expect(StorageAssetService::MicrosoftGraph::Oauth2Token).to_not receive(:new)
        StorageAssetSession.microsoft_graph_token
      end

      it 'returns the record with the setting of microsoft_graph_token if it exists' do
        expect(StorageAssetSession.microsoft_graph_token).to eq(access_token)
      end
    end

    context 'when microsoft_graph_token setting does not exist or is expired' do
      let(:token_double) { instance_double(StorageAssetService::MicrosoftGraph::Oauth2Token, call: { access_token: 'latest_token', expires_in: 3_600 }) }

      before do
        allow(StorageAssetService::MicrosoftGraph::Oauth2Token).to receive(:new).and_return(token_double)
      end

      around do |example|
        freeze_time { example.run }
      end

      it 'calls the StorageAssetService::MicrosoftGraph::Oauth2Token service and creates a new setting if it does not exist' do
        expect(StorageAssetService::MicrosoftGraph::Oauth2Token).to receive(:new).and_return(token_double)

        expect do
          StorageAssetSession.microsoft_graph_token
        end.to change(StorageAssetSession, :count).by(1)

        session = StorageAssetSession.last
        expect(session.setting).to eq(StorageAssetSession::MICROSOFT_GRAPH_TOKEN)
        expect(session.value).to eq('latest_token')
        expect(session.expires_at).to eq(3_600.seconds.from_now)
      end

      it 'calls the StorageAssetService::MicrosoftGraph::Oauth2Token service and updates an existing token if the setting has expired' do
        access_token = FactoryBot.create(:storage_asset_session, :microsoft_graph_token, expires_at: 1.hour.ago)

        expect(StorageAssetService::MicrosoftGraph::Oauth2Token).to receive(:new).and_return(token_double)

        expect do
          StorageAssetSession.microsoft_graph_token
        end.to_not change(StorageAssetSession, :count)

        access_token.reload
        expect(access_token.value).to eq('latest_token')
        expect(access_token.expires_at).to eq(3_600.seconds.from_now)
      end

      it 'returns the newly created record when created' do
        session = StorageAssetSession.microsoft_graph_token
        expect(session).to eq(StorageAssetSession.last)
      end

      it 'returns the newly created record when updated' do
        access_token = FactoryBot.create(:storage_asset_session, :microsoft_graph_token, expires_at: 1.hour.ago)
        session = StorageAssetSession.microsoft_graph_token
        expect(session).to eq(access_token)
      end
    end
  end

  describe '.microsoft_graph_delta_token' do
    it 'returns the record with the setting of microsoft_graph_delta if it exists' do
      delta_token = FactoryBot.create(:storage_asset_session, setting: StorageAssetSession::MICROSOFT_GRAPH_DELTA, value: 'delta_token')

      expect(StorageAssetSession.microsoft_graph_delta_token).to eq(delta_token)
    end
  end
end

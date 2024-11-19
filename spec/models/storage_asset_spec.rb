require 'rails_helper'

RSpec.describe StorageAsset, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:service) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:full_path) }
    it { is_expected.to validate_presence_of(:size_bytes) }
    it { is_expected.to validate_numericality_of(:size_bytes).only_integer }
  end

  describe 'scopes' do
    context '.azure' do
      it 'returns records where the service is StorageAssetServices::AZURE' do
        azure_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE)
        dropbox_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX)
        sharepoint_asset = FactoryBot.create(:storage_asset, service: 'SharePoint')

        storage_assets = StorageAsset.azure
        expect(storage_assets).to include(azure_asset)
        expect(storage_assets).to_not include(dropbox_asset, sharepoint_asset)
      end
    end

    context '.dropbox' do
      it 'returns records where the service is StorageAssetServices::DROPBOX' do
        azure_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE)
        dropbox_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX)
        sharepoint_asset = FactoryBot.create(:storage_asset, service: 'SharePoint')

        storage_assets = StorageAsset.dropbox
        expect(storage_assets).to include(dropbox_asset)
        expect(storage_assets).to_not include(azure_asset, sharepoint_asset)
      end
    end

    context '.s3' do
      it 'returns records where the service is StorageAssetServices::S3' do
        azure_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE)
        dropbox_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX)
        s3_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3)

        storage_assets = StorageAsset.s3
        expect(storage_assets).to include(s3_asset)
        expect(storage_assets).to_not include(azure_asset, dropbox_asset)
      end
    end

    context '.sharepoint' do
      it 'returns records where the service is StorageAssetServices::SHAREPOINT' do
        sharepoint_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::SHAREPOINT)
        dropbox_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX)
        s3_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3)

        storage_assets = StorageAsset.sharepoint
        expect(storage_assets).to include(sharepoint_asset)
        expect(storage_assets).to_not include(s3_asset, dropbox_asset)
      end
    end
  end

  describe '.process_dropbox_assets' do
    let(:assets) { JSON.parse(file_fixture('dropbox_list_folders_response.json').read).deep_symbolize_keys }

    it 'iterates through a list of Dropbox assets from an API response and creates new StorageAsset records only when .tag is file' do
      expect do
        StorageAsset.process_dropbox_assets(assets)
      end.to change(StorageAsset, :count).by(1)

      storage_asset = StorageAsset.last
      expect(storage_asset.service).to eq(StorageAssetServices::DROPBOX)
      expect(storage_asset.name).to eq('clip1.mov')
      expect(storage_asset.full_path).to eq('/Movies/Movie/clip1.mov')
      expect(storage_asset.size_bytes).to eq(4_244_976)
      expect(storage_asset.asset_updated_at).to eq(Time.parse('2019-08-12T13:22:18Z'))
    end

    it 'updates existing StorageAsset records for Dropbox assets based on the full path' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX, full_path: '/Movies/Movie/clip1.mov', size_bytes: 123_456)

      expect do
        StorageAsset.process_dropbox_assets(assets)
        storage_asset.reload
      end.to change(storage_asset, :size_bytes).from(123_456).to(4_244_976)
    end

    it 'deletes StorageAsset records for Dropbox assets where .tag is deleted' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX, full_path: '/Movies/Movie/clip-old.mov')

      StorageAsset.process_dropbox_assets(assets)
      expect(StorageAsset.exists?(storage_asset.id)).to eq(false)
    end

    it 'does not delete any StorageAsset records if the service is not from Dropbox' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, full_path: '/Movies/Movie/clip-old.mov')

      StorageAsset.process_dropbox_assets(assets)
      expect(StorageAsset.exists?(storage_asset.id)).to eq(true)
    end
  end

  describe '#allow_temporary_url?' do
    it 'returns false if service is Azure and access tier is StorageAssetServiceTiers::AZURE::ARCHIVE' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, access_tier: StorageAssetServiceTiers::AZURE::ARCHIVE)
      expect(storage_asset.allow_temporary_url?).to eq(false)
    end

    it 'returns false if service is Azure and access tier is StorageAssetServiceTiers::AZURE::UNARCHIVING' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, access_tier: StorageAssetServiceTiers::AZURE::UNARCHIVING)
      expect(storage_asset.allow_temporary_url?).to eq(false)
    end

    it 'returns false if service is S3 and access tier is StorageAssetServiceTiers::AWS::GLACIER' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, access_tier: StorageAssetServiceTiers::AWS::GLACIER)
      expect(storage_asset.allow_temporary_url?).to eq(false)
    end

    it 'returns false if service is S3 and access tier is StorageAssetServiceTiers::AWS::DEEP_ARCHIVE' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, access_tier: StorageAssetServiceTiers::AWS::DEEP_ARCHIVE)
      expect(storage_asset.allow_temporary_url?).to eq(false)
    end

    it 'returns false if service is S3 and access tier is StorageAssetServiceTiers::AWS::UNARCHIVING' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, access_tier: StorageAssetServiceTiers::AWS::UNARCHIVING)
      expect(storage_asset.allow_temporary_url?).to eq(false)
    end

    it 'returns true if storage asset allows temporary download URLs' do
      storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, access_tier: StorageAssetServiceTiers::AZURE::COOL)
      expect(storage_asset.allow_temporary_url?).to eq(true)
    end
  end

  describe '#generate_temporary_url!' do
    context 'when the storage asset has a valid temporary URL' do
      let(:azure_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, temporary_url: 'https://service.com/download/12345', temporary_url_expires_at: 12.hours.from_now) }
      let(:dropbox_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX, temporary_url: 'https://service.com/download/12345', temporary_url_expires_at: 12.hours.from_now) }
      let(:s3_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, temporary_url: 'https://service.com/download/12345', temporary_url_expires_at: 12.hours.from_now) }
      let(:sharepoint_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::SHAREPOINT, temporary_url: 'https://service.com/download/12345', temporary_url_expires_at: 30.minutes.from_now) }

      it 'does not call StorageAssetService::Azure::GenerateTemporaryUrl when service is StorageAssetServices::AZURE' do
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).not_to receive(:new)
        azure_storage_asset.generate_temporary_url!
      end

      it 'does not call StorageAssetService::Dropbox::GenerateTemporaryUrl when service is StorageAssetServices::DROPBOX' do
        expect(StorageAssetService::Dropbox::GenerateTemporaryUrl).not_to receive(:new)
        dropbox_storage_asset.generate_temporary_url!
      end

      it 'does not call StorageAssetService::S3::GenerateTemporaryUrl when service is StorageAssetServices::S3' do
        expect(StorageAssetService::S3::GenerateTemporaryUrl).not_to receive(:new)
        s3_storage_asset.generate_temporary_url!
      end

      it 'does not call StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl when service is StorageAssetServices::SHAREPOINT' do
        expect(StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl).not_to receive(:new)
        sharepoint_storage_asset.generate_temporary_url!
      end

      it 'returns nil' do
        expect(azure_storage_asset.generate_temporary_url!).to eq(nil)
      end
    end

    context 'when the storage asset does not have a valid temporary URL' do
      let(:azure_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, temporary_url: nil, temporary_url_expires_at: nil) }
      let(:dropbox_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX, temporary_url: nil, temporary_url_expires_at: nil) }
      let(:s3_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, temporary_url: nil, temporary_url_expires_at: nil) }
      let(:sharepoint_storage_asset) { FactoryBot.create(:storage_asset, service: StorageAssetServices::SHAREPOINT, temporary_url: nil, temporary_url_expires_at: nil) }
      let(:service_double) { double(call: { url: 'https://service.com/download/12345', expires_at: 1.day.from_now }) }

      around do |example|
        freeze_time { example.run }
      end

      it 'calls StorageAssetService::Azure::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::AZURE and does not have a temporary URL' do
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).to receive(:new).with(azure_storage_asset).and_return(service_double)
        azure_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::Azure::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::AZURE and the temporary URL has expired' do
        azure_storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::AZURE, temporary_url: 'https://azure.com/download/12345', temporary_url_expires_at: 1.hour.ago)
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).to receive(:new).with(azure_storage_asset).and_return(service_double)
        azure_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::Dropbox::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::DROPBOX and does not have a temporary URL' do
        expect(StorageAssetService::Dropbox::GenerateTemporaryUrl).to receive(:new).with(dropbox_storage_asset).and_return(service_double)
        dropbox_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::Dropbox::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::DROPBOX and the temporary URL has expired' do
        dropbox_storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::DROPBOX, temporary_url: 'https://dropbox.com/download/12345', temporary_url_expires_at: 1.hour.ago)
        expect(StorageAssetService::Dropbox::GenerateTemporaryUrl).to receive(:new).with(dropbox_storage_asset).and_return(service_double)
        dropbox_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::S3::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::S3 and does not have a temporary URL' do
        expect(StorageAssetService::S3::GenerateTemporaryUrl).to receive(:new).with(s3_storage_asset).and_return(service_double)
        s3_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::S3::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::S3 and the temporary URL has expired' do
        s3_storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::S3, temporary_url: 'https://wpa-media.s3.amazonaws.com/download/12345', temporary_url_expires_at: 1.hour.ago)
        expect(StorageAssetService::S3::GenerateTemporaryUrl).to receive(:new).with(s3_storage_asset).and_return(service_double)
        s3_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::SHAREPOINT and does not have a temporary URL' do
        expect(StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl).to receive(:new).with(sharepoint_storage_asset).and_return(service_double)
        sharepoint_storage_asset.generate_temporary_url!
      end

      it 'calls StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl if the storage asset service is StorageAssetServices::SHAREPOINT and the temporary URL has expired' do
        sharepoint_storage_asset = FactoryBot.create(:storage_asset, service: StorageAssetServices::SHAREPOINT, temporary_url: 'https://sharepoint.com/download/12345', temporary_url_expires_at: 1.hour.ago)
        expect(StorageAssetService::MicrosoftGraph::GenerateTemporaryUrl).to receive(:new).with(sharepoint_storage_asset).and_return(service_double)
        sharepoint_storage_asset.generate_temporary_url!
      end

      it 'sets the temporary URL and expiration timestamp for the storage asset' do
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).to receive(:new).with(azure_storage_asset).and_return(service_double)
        azure_storage_asset.generate_temporary_url!

        expect(azure_storage_asset.temporary_url).to eq('https://service.com/download/12345')
        expect(azure_storage_asset.temporary_url_expires_at).to eq(1.day.from_now)
      end

      it 'returns true if the storage asset was updated successfully' do
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).to receive(:new).with(azure_storage_asset).and_return(service_double)
        allow(azure_storage_asset).to receive(:update_columns).and_return(true)
        expect(azure_storage_asset.generate_temporary_url!).to eq(true)
      end

      it 'returns false if the storage asset was not updated successfully' do
        expect(StorageAssetService::Azure::GenerateTemporaryUrl).to receive(:new).with(azure_storage_asset).and_return(service_double)
        allow(azure_storage_asset).to receive(:update_columns).and_return(false)
        expect(azure_storage_asset.generate_temporary_url!).to eq(false)
      end
    end
  end

  describe '#unarchive_on_azure!' do
    let(:storage_asset) { FactoryBot.create(:storage_asset, :azure_archive) }
    let(:service_double) { double(call: true) }

    it 'calls the StorageAssetService::Azure::UnarchiveBlob service object with the storage asset' do
      expect(StorageAssetService::Azure::UnarchiveBlob).to receive(:new).with(storage_asset).and_return(service_double)
      storage_asset.unarchive_on_azure!
    end

    it 'updates the access tier of the storage asset to StorageAssetServiceTiers::AZURE::UNARCHIVING' do
      allow(StorageAssetService::Azure::UnarchiveBlob).to receive(:new).and_return(service_double)

      expect do
        storage_asset.unarchive_on_azure!
      end.to change(storage_asset, :access_tier).from(StorageAssetServiceTiers::AZURE::ARCHIVE).to(StorageAssetServiceTiers::AZURE::UNARCHIVING)
    end
  end

  describe '#unarchive_on_s3!' do
    let(:storage_asset) { FactoryBot.create(:storage_asset, :s3_glacier) }
    let(:service_double) { double(call: true) }

    it 'calls the StorageAssetService::S3::RestoreObject service object with the storage asset' do
      expect(StorageAssetService::S3::RestoreObject).to receive(:new).with(storage_asset).and_return(service_double)
      storage_asset.unarchive_on_s3!
    end

    it 'updates the access tier of the storage asset to StorageAssetServiceTiers::AWS::UNARCHIVING' do
      allow(StorageAssetService::S3::RestoreObject).to receive(:new).and_return(service_double)

      expect do
        storage_asset.unarchive_on_s3!
      end.to change(storage_asset, :access_tier).from(StorageAssetServiceTiers::AWS::GLACIER).to(StorageAssetServiceTiers::AWS::UNARCHIVING)
    end
  end

  describe '#root_folder' do
    it 'returns the root folder of the storage asset based on the full path' do
      storage_asset = build(:storage_asset, full_path: '/Movies/Movie/clip1.mov')
      expect(storage_asset.root_folder).to eq('Movies')
    end
  end

  describe '#key' do
    it 'returns the path after the root folder of the storage asset full path' do
      storage_asset = build(:storage_asset, full_path: '/Movies/Movie/clip1.mov')
      expect(storage_asset.key).to eq('Movie/clip1.mov')
    end
  end
end

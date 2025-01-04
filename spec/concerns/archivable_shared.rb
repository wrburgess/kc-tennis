require 'rails_helper'

shared_examples 'archivable' do
  it 'is active by default' do
    instance_of_class = FactoryBot.create(described_class.to_s.underscore.to_sym)
    expect(instance_of_class.active?).to be_truthy
  end

  it 'is not archived by default' do
    instance_of_class = FactoryBot.create(described_class.to_s.underscore.to_sym)
    expect(instance_of_class.archived?).to be_falsey
  end

  describe '.archive' do
    it 'archives the instance' do
      instance_of_class = FactoryBot.create(described_class.name.underscore.to_sym, archived_at: DateTime.current)
      instance_of_class.archive
      instance_of_class.reload
      expect(instance_of_class.archived?).to be_truthy
      expect(instance_of_class.active?).to be_falsey
    end
  end

  describe '.unarchive' do
    it 'unarchives the instance' do
      instance_of_class = FactoryBot.create(described_class.name.underscore.to_sym, archived_at: DateTime.current)
      instance_of_class.unarchive
      instance_of_class.reload
      expect(instance_of_class.archived?).to be_falsey
      expect(instance_of_class.active?).to be_truthy
    end
  end

  describe '.active?' do
    it 'indicates the instance is active' do
      instance_of_class = FactoryBot.create(described_class.name.underscore.to_sym, archived_at: nil)
      expect(instance_of_class.active?).to be_truthy
    end
  end

  describe '.archived?' do
    it 'indicates the instance is archived' do
      instance_of_class = FactoryBot.create(described_class.name.underscore.to_sym, archived_at: DateTime.current)
      expect(instance_of_class.archived?).to be_truthy
    end
  end

  describe '.actives' do
    it 'only selects instances where archived_at is nil' do
      instance_1 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_2 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_3 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_3.archive
      instance_3.reload
      expect(described_class.count).to eq 3
      expect(described_class.actives.count).to eq 2
    end
  end

  describe '.archives' do
    it 'only selects instances where archived_at is not nil' do
      instance_1 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_2 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_3 = FactoryBot.create(described_class.name.underscore.to_sym)
      instance_1.archive
      instance_3.archive
      instance_1.reload
      instance_3.reload
      expect(described_class.count).to eq 3
      expect(described_class.archives.count).to eq 2
    end
  end
end

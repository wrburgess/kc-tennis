module StorageAssetServiceTiers
  module AWS
    STANDARD = 'STANDARD'.freeze
    INTELLIGENT_TIERING = 'INTELLIGENT_TIERING'.freeze
    STANDARD_IA = 'STANDARD_IA'.freeze
    ONEZONE_IA = 'ONEZONE_IA'.freeze
    GLACIER_IR = 'GLACIER_IR'.freeze
    GLACIER = 'GLACIER'.freeze
    DEEP_ARCHIVE = 'DEEP_ARCHIVE'.freeze
    EXPRESS_ONEZONE = 'EXPRESS_ONEZONE'.freeze

    # The following are used to mark when a blob is being unarchived only.
    UNARCHIVING = 'Unarchiving in Progress'.freeze
    TEMPORARILY_RESTORED = 'Temporarily Restored'.freeze

    def self.all
      constants.map { |constant| const_get(constant) }
    end

    def self.options_for_select
      all.map { |storage_class| [storage_class.titleize, storage_class] }
    end
  end

  module AZURE
    HOT = 'Hot'.freeze
    COOL = 'Cool'.freeze
    COLD = 'Cold'.freeze
    ARCHIVE = 'Archive'.freeze

    # The following is used to mark when a blob is being unarchived only.
    UNARCHIVING = 'Unarchiving in Progress'.freeze

    def self.all
      constants.map { |constant| const_get(constant) }
    end

    def self.options_for_select
      all.map { |storage_class| [storage_class.titleize, storage_class] }
    end
  end

  def self.all
    AWS.all + AZURE.all
  end

  def self.options_for_select
    AWS.options_for_select + AZURE.options_for_select
  end
end

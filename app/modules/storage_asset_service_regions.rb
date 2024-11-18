module StorageAssetServiceRegions
  module AWS
    US_EAST_1 = 'us-east-1'.freeze
    US_EAST_2 = 'us-east-2'.freeze
    US_WEST_1 = 'us-west-1'.freeze
    US_WEST_2 = 'us-west-2'.freeze

    def self.all
      constants.map { |constant| const_get(constant) }
    end

    def self.options_for_select
      all.map { |region| [region.titleize, region] }
    end
  end

  module AZURE
    EAST_US = 'eastus'.freeze
    EAST_US_2 = 'eastus2'.freeze
    CENTRAL_US = 'centralus'.freeze
    NORTH_CENTRAL_US = 'northcentralus'.freeze
    SOUTH_CENTRAL_US = 'southcentralus'.freeze
    WEST_US = 'westus'.freeze
    WEST_US_2 = 'westus2'.freeze
    WEST_US_3 = 'westus3'.freeze

    def self.all
      constants.map { |constant| const_get(constant) }
    end

    def self.options_for_select
      all.map { |region| [region.titleize, region] }
    end
  end

  def self.all
    AWS.all + AZURE.all
  end

  def self.options_for_select
    AWS.options_for_select + AZURE.options_for_select
  end
end

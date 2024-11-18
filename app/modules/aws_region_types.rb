module AwsRegionTypes
  US_EAST_1 = 'us-east-1'.freeze
  US_EAST_2 = 'us-east-2'.freeze
  US_WEST_1 = 'us-west-1'.freeze
  US_WEST_2 = 'us-west-2'.freeze

  def self.all
    [self::US_EAST_1, self::US_EAST_2, self::US_WEST_1, self::US_WEST_2]
  end
end

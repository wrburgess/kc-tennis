class TennisSinglesMatchCard::Component < ApplicationComponent
  attr_reader :match_record

  def initialize(match_record:)
    @match_record = match_record.with_indifferent_access
  end
end

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#default_date_format' do
    it 'returns same value if a non-date value is submitted' do
      submitted_value = Faker::Lorem.word
      expect(default_date_format(submitted_value)).to eq submitted_value
    end

    it 'returns the properly formatted date value if date is submitted' do
      submitted_value = Faker::Date.between(from: 2.years.ago, to: Time.zone.today)
      expect(default_date_format(submitted_value)).to eq submitted_value.strftime('%b %e, %Y')
    end

    it 'returns nil if nil is submitted' do
      submitted_value = nil
      expect(default_date_format(submitted_value)).to be_nil
    end
  end
end

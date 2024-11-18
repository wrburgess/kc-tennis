require "rails_helper"
# require "concerns/archivable_shared"

describe User, type: :model do
  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  it "is invalid without an email address" do
    expect(FactoryBot.build(:user, password: nil)).not_to be_valid
  end

  it "is invalid without a password" do
    expect(FactoryBot.build(:user, password: nil)).not_to be_valid
  end

  describe "#full_name" do
    it "renders the user first and last name separated by a space" do
      user = create(:user, first_name: "Bubba", last_name: "Jones")
      expect(user.full_name).to eq "#{user.first_name.capitalize} #{user.last_name.capitalize}"
    end

    it "capitalizes the user first and last names" do
      user = create(:user, first_name: "bubba", last_name: "jones")
      expect(user.full_name).to eq "#{user.first_name.capitalize} #{user.last_name.capitalize}"
    end

    it "capitalizes the user first name and trims any pre-fixed space" do
      user = create(:user, first_name: "bubba", last_name: "")
      expect(user.full_name).to eq user.first_name.capitalize
    end

    it "capitalizes the user last name and trims any post-fixed space" do
      user = create(:user, first_name: "", last_name: "jones")
      expect(user.full_name).to eq user.last_name.capitalize
    end

    context "nil names" do
      it "capitalizes the user last name and trims any post-fixed space" do
        user = create(:user, first_name: nil, last_name: "jones")
        expect(user.full_name).to eq user.last_name.capitalize
      end

      it "capitalizes the user first name and trims any post-fixed space" do
        user = create(:user, first_name: "bubba", last_name: nil)
        expect(user.full_name).to eq user.first_name.capitalize
      end
    end
  end
end

class StorageAssetSession < ApplicationRecord
  DROPBOX_CURSOR = 'dropbox_cursor'.freeze
  DROPBOX_ACCESS_TOKEN = 'dropbox_access_token'.freeze
  MICROSOFT_GRAPH_TOKEN = 'microsoft_graph_token'.freeze
  MICROSOFT_GRAPH_DELTA = 'microsoft_graph_delta'.freeze
  EXPIRABLE_SETTINGS = [DROPBOX_ACCESS_TOKEN, MICROSOFT_GRAPH_TOKEN].freeze

  validates :setting, presence: true, uniqueness: true
  validates :value, presence: true
  validate :check_expires_at_presence

  def self.dropbox_cursor
    cursor = find_by(setting: DROPBOX_CURSOR)
    return cursor unless cursor.nil?

    latest_cursor = StorageAssetService::Dropbox::GetLatestCursor.new.call
    create(setting: DROPBOX_CURSOR, value: latest_cursor)
  end

  def self.dropbox_access_token
    access_token = find_by(setting: DROPBOX_ACCESS_TOKEN)
    return access_token unless access_token.nil? || access_token.expires_at < Time.current

    oauth2_token = StorageAssetService::Dropbox::Oauth2Token.new.call

    if access_token.nil?
      create(setting: DROPBOX_ACCESS_TOKEN, value: oauth2_token[:access_token], expires_at: oauth2_token[:expires_in].seconds.from_now)
    else
      access_token.update(value: oauth2_token[:access_token], expires_at: oauth2_token[:expires_in].seconds.from_now)
      access_token
    end
  end

  def self.microsoft_graph_token
    access_token = find_by(setting: MICROSOFT_GRAPH_TOKEN)
    return access_token unless access_token.nil? || access_token.expires_at < Time.current

    oauth2_token = StorageAssetService::MicrosoftGraph::Oauth2Token.new.call

    if access_token.nil?
      create(setting: MICROSOFT_GRAPH_TOKEN, value: oauth2_token[:access_token], expires_at: oauth2_token[:expires_in].seconds.from_now)
    else
      access_token.update(value: oauth2_token[:access_token], expires_at: oauth2_token[:expires_in].seconds.from_now)
      access_token
    end
  end

  def self.microsoft_graph_delta_token
    find_by(setting: MICROSOFT_GRAPH_DELTA)
  end

  private

  def check_expires_at_presence
    return unless EXPIRABLE_SETTINGS.include?(setting)

    errors.add(:expires_at, "can't be blank") if expires_at.blank?
  end
end

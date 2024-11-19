module UrlTypes
  OTHER = 'other'.freeze
  VIMEO = 'vimeo'.freeze
  WEBSITE = 'website'.freeze
  YOUTUBE = 'youtube'.freeze

  def self.all
    constants.map { |const| const_get(const) }
  end
end

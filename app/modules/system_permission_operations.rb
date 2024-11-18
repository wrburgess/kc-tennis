module SystemPermissionOperations
  COPY = "copy".freeze
  CREATE = "create".freeze
  CREATE_FROM_UPLOAD = "create_from_upload".freeze
  EDIT = "edit".freeze
  EXPORT_EXAMPLE = "export_example".freeze
  EXPORT_XLSX = "export_xlsx".freeze
  IMPORT = "import".freeze
  INDEX = "index".freeze
  NEW = "new".freeze
  READ = "read".freeze
  SHARE = "share".freeze
  UPDATE = "update".freeze
  UPLOAD = "upload".freeze
  DISASSOCIATE = "disassociate".freeze

  def self.options_for_select
    all.map { |item| [ item.upcase, item ] }
  end

  def self.all
    constants.map(&:to_s).map(&:downcase)
  end
end

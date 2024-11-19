module SystemOperations
  COLLECTION_EXPORT_XLSX = 'collection_export_xlsx'.freeze
  COPY = 'copy'.freeze
  CREATE = 'create'.freeze
  CREATE_FROM_UPLOAD = 'create_from_upload'.freeze
  DISASSOCIATE = 'disassociate'.freeze
  EDIT = 'edit'.freeze
  EXPORT_EXAMPLE = 'export_example'.freeze
  IMPORT = 'import'.freeze
  INDEX = 'index'.freeze
  MEMBER_EXPORT_XLSX = 'member_export_xlsx'.freeze
  NEW = 'new'.freeze
  READ = 'read'.freeze
  SHARE = 'share'.freeze
  UPDATE = 'update'.freeze
  UPLOAD = 'upload'.freeze

  def self.options_for_select
    all.map { |item| [item.upcase, item] }
  end

  def self.all
    constants.map(&:to_s).map(&:downcase)
  end
end

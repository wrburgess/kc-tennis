module AwsEventTypes
  OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD = 'ObjectCreated:CompleteMultipartUpload'.freeze
  OBJECT_CREATED_COPY = 'ObjectCreated:Copy'.freeze
  OBJECT_CREATED_POST = 'ObjectCreated:Post'.freeze
  OBJECT_CREATED_PUT = 'ObjectCreated:Put'.freeze
  OBJECT_REMOVED_DELETE = 'ObjectRemoved:Delete'.freeze
  OBJECT_REMOVED_DELETE_MARKER_CREATED = 'ObjectRemoved:DeleteMarkerCreated'.freeze
  OBJECT_RESTORE_COMPLETED = 'ObjectRestore:Completed'.freeze
  OBJECT_RESTORE_POST = 'ObjectRestore:Post'.freeze

  def self.all
    [
      self::OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD,
      self::OBJECT_CREATED_COPY,
      self::OBJECT_CREATED_POST,
      self::OBJECT_CREATED_PUT,
      self::OBJECT_REMOVED_DELETE,
      self::OBJECT_REMOVED_DELETE_MARKER_CREATED,
      self::OBJECT_RESTORE_COMPLETED,
      self::OBJECT_RESTORE_POST
    ]
  end

  def self.created
    [
      self::OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD,
      self::OBJECT_CREATED_COPY,
      self::OBJECT_CREATED_POST,
      self::OBJECT_CREATED_PUT
    ]
  end

  def self.removed
    [
      self::OBJECT_REMOVED_DELETE,
      self::OBJECT_REMOVED_DELETE_MARKER_CREATED
    ]
  end

  def self.restore
    [
      self::OBJECT_RESTORE_COMPLETED,
      self::OBJECT_RESTORE_POST
    ]
  end
end

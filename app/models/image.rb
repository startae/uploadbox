class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  def process
    update(remote_file_url: original_file)
  end

  def processing?
    file.blank?
  end
end

# encoding: utf-8

class PlaceholderUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process :resize_to_fit => [1280, 720]
  
  version :thumb do
    process :resize_to_fill => [320,180]
  end

  def default_url
    "/images/" + [version_name, "default.jpg"].compact.join('_')
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end

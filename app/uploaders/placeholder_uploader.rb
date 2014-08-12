# encoding: utf-8

class PlaceholderUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  process :resize_to_limit => [1280, 720]
  
  version :thumb do
    process :only_first_frame
    process :resize_to_limit => [350, 200]
  end

  def default_url
    "/images/" + [version_name, "default.jpg"].compact.join('_')
  end

  def extension_white_list
    %w(jpg jpeg png)
  end
  
  def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  def only_first_frame
    manipulate! do |img|
      if img.mime_type.match /gif/
        if img.scene == 0
          img = img.cur_image #Magick::ImageList.new( img.base_filename )[0]
          else
            img = nil # avoid concat all frames
        end
      end
      img
    end
  end
  
  protected
  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end

end

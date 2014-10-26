# encoding: utf-8

class ItemImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  ## set in initializers/carrierwave.rb

  # Override the directory where uploaded files will be stored.
  def store_dir
    store_name = model.store_name.blank? ? "NA" : model.store_name
    designer = model.designer.blank? ? "NA" : model.designer
    product_name = model.product_name.blank? ? "NA" : model.product_name
    date = Time.now.strftime("%m%d%y")

    # sanitize and truncate strings
    store_name = store_name.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_').truncate(10)
    designer = designer.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_')
    product_name = product_name.gsub(' ', '_').gsub('%20', '_').gsub(/[^\.0-9a-z_-]/i, '_').truncate(20)

    "items/#{store_name}/#{designer}/#{product_name}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end

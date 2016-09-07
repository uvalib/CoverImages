module ResqueWeb::Plugins::CoverImage
  class Engine < Rails::Engine
    # isolate or not?
    isolate_namespace ResqueWeb::Plugins::CoverImage
  end
  def self.engine_path
    "/admin/cover_images"
  end
  # Tells Resque web what extra tabs to add to the main navigation at the
  # top of the resque-web interface.
  #
  # @return [Array]
  def self.tabs
    [{'Cover Image Admin' => '/admin/cover_images'}]
  end
end


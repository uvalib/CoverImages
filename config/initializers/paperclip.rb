# allow paperclip to accept the poorly formatted file names from syndetics
Paperclip.options[:content_type_mappings] = { aspx: 'image/jpeg' }
Paperclip::UriAdapter.register
Paperclip::HttpUrlProxyAdapter

require 'paperclip/media_type_spoof_detector'
module Paperclip
  # Disable spoofing check because syndetics doesn't follow standards
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

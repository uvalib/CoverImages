# allow paperclip to accept the poorly formatted file names from syndetics
Paperclip.options[:content_type_mappings] = { aspx: 'image/jpeg' }

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end


# allow paperclip to accept the poorly formatted file names from syndetics
Paperclip.options[:content_type_mappings] = { aspx: 'image/jpeg' }

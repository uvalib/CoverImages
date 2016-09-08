module Admin::CoverImagesHelper
  def status_label status
    label_name = ''
    case status
    when 'unprocessed'
      label_name = 'label-default'
    when 'error'
      label_name = 'label-danger'
    when 'not_found'
      label_name = 'label-warning'
    when 'processed'
      label_name = 'label-success'
    end
    content_tag 'span', status, class: "label #{label_name}"
  end
end

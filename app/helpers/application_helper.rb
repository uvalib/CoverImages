# Application helpers available site-wide
module ApplicationHelper

  def bootstrap_class_for(flash_type)
    {
      success: "alert-success",
      error:   "alert-danger",
      alert:   "alert-warning",
      notice:  "alert-info"
    }[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages
    flash.each do |msg_type, message|
      concat(
        content_tag(
          :div, message,
          class: "alert #{bootstrap_class_for(msg_type)} fade in") do

          concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
          concat message
        end
      )
    end
    nil
  end

  def nav_link(link_text, link_path)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path
    end
  end

  def short_date(datetime)
    datetime.try :strftime, '%b %e, %Y'
  end
end

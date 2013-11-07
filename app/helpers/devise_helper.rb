module DeviseHelper

  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |message| content_tag(:p, message) }.join
    html = %Q[<div class="alert">
                #{messages}
              </div>]

    html.html_safe
  end

end
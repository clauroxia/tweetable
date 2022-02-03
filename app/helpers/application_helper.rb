module ApplicationHelper
  def error_for(record, attribute)
    errors = record.errors.full_messages_for(attribute).map do |message|
      content_tag(:span, message)
    end

    safe_join(errors)
  end
end

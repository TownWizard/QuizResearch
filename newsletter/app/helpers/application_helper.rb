# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def body_classes
    case controller.controller_name
    when "newsletters"
      controller.action_name.eql?("show") ? "newsletters" : ""
    when "subscribers"
      case controller.action_name
      when "edit"
        "subscribers"
      when "create"
        "newsletters"
      when "unsubscribe"
        "unsubscribe"
      else
        ""
      end
    when "invitations"
      case controller.action_name
      when "new"
        "subscribers"
      when "create"
        "subscribers"
      end
    end
  end

end

module ApplicationHelper

  def nav_link_class(controller, action)
    if controller_name == controller and action_name == action
      'active'
    else
      ''
    end
  end

  def new_create_nav_link_class(controller)
    if controller_name == controller and (action_name == 'new' or action_name == 'create')
      'active'
    else
      ''
    end
  end

  def edit_create_nav_link_class(controller)
    if controller_name == controller and (action_name == 'edit' or action_name == 'update')
      'active'
    else
      ''
    end
  end
    
end

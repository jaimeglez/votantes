module ApplicationHelper
  def coordinator_name(area)
    area.coordinator ? area.coordinator.full_name : 'No asignado'
  end

  def active_label(area)
    area.active ? 'Si' : 'No'
  end

  def active_options
    [['Si', true], ['No', false]]
  end

  def active_menu_option(path, extra = {})
    return '' unless path == controller_name && (extra.to_a - params.to_a).empty?
    'active'
  end
end

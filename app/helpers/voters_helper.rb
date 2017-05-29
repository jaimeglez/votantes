module VotersHelper
  def roles_options
    Voter::ROLES.map{|k,v| [v,k]}
  end

  def areas_name(voter)
    areas = voter.areas
    return if areas.blank?
    if areas.class.name == 'ActiveRecord::Associations::CollectionProxy'
      areas.map(&:name).join('-')
    else
      areas.name
    end
  end

  def group_values(fields)
    fields.map{|field| [I18n.t("voter.#{field}"), field]}
  end
end

module VotersHelper
  def roles_options
    Voter::ROLES.map{|k,v| [v,k]}
  end

  # def areas_name(voter)
  def in_charge_of_name(voter)
    areas = voter.areas
    return if areas.blank?
    if voter.role == Voter::PROMOTER
      areas.map(&:full_name).join('-')
    else
      areas.map(&:with_parents_name).join('-')
    end
  end

  def group_values(fields)
    fields.map{|field| [I18n.t("voter.#{field}"), field]}
  end
end

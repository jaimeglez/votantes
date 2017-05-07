module VotersHelper
  def roles_options
    Voter::ROLES.map{|k,v| [v,k]}
  end

  def areas_name(voter)
    areas = voter.areas
    return if areas.nil?
    areas.map(&:name).join('-')
  end
end

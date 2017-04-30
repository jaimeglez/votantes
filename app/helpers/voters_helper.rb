module VotersHelper
  def roles_collection
    Voter::ROLES.map{|label, value| [value, label]}
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      can :manage, ExchangeReport, user_id: user.id
    end
  end
end

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :seller
      can :create, :booking
      can :view, :home

    else
      can :view, :home
      can :view, :seller_session
      can :view, :admin_session
    end
  end
end

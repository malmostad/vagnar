class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin
      can :manage, :all

    elsif user.has_role? :seller
      can :create, :booking
      can :read, :login
      can :read, :info

    else
      can :view, :home
      can :read, :login
      can :read, :info
    end
  end
end

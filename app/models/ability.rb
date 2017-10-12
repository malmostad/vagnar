class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user == current_admin
      can :manage, :all
      cannot :destroy, User

    elsif user == current_user
      can :create, :booking
      cannot :destroy, User
      can :read, :login
      can :read, :info

    else
      can :read, :login
      can :read, :info
    end
  end
end

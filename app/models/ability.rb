class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.has_role? :admin
      can :manage, :all
      cannot :destroy, User

    elsif user.has_role? :client
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

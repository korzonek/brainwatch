class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, :all
    if user
      can :create, [Question, Answer, Comment]
      can [:update, :destroy], [Question, Answer, Comment], user: user
      can :vote, [Question, Answer]
      can :accept, Answer, question: {user: user}
    end
  end
end

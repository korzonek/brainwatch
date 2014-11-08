describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
    it { should_not be_able_to :vote, Question }
    it { should_not be_able_to :accept, Answer }
    it { should_not be_able_to :create, :all }
  end

  describe 'for user' do
    let (:user) { create(:user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    let(:other) { create(:user) }

    it { should_not be_able_to :update, create(:question, user: create(:user)), user: user }
    it { should_not be_able_to :destroy, create(:question, user: create(:user)), user: user }
    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :vote, create(:question, user: create(:user)) }

    it { should be_able_to :accept, create(:answer, question: create(:question, user: user), user: user) }
    it { should_not be_able_to :accept, create(:answer, question: create(:question, user: create(:user)), user: user) }
  end
end
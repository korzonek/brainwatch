# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_questions_on_user_id  (user_id)
#

require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attachments}
  it { should accept_nested_attributes_for :attachments}

  let (:question) { create(:question, answers: create_list(:answer, 3)) }

  context 'accept answer' do
    before :each do
      answer = question.answers.last
      answer.update(accepted: true)
      question.reload
    end

    it "should find accepted answer" do
      expect(question.accepted_answer).to eq question.answers.last
    end

    it "should change accepted answer" do
      answer_to_accept = question.answers.first
      question.accept_answer(answer_to_accept)
      expect(question.accepted_answer).to eq question.answers.first
      expect(question.answers.find_all{|a|a.accepted}).to eq [answer_to_accept]
    end
  end

end

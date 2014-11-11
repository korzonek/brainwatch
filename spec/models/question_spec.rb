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

RSpec.describe Question, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :attachments }
  it { should accept_nested_attributes_for :attachments }

  let(:question) { create(:question, answers: create_list(:answer, 3)) }

  context 'accept answer' do
    before :each do
      answer = question.answers.last
      answer.update(accepted: true)
      question.reload
    end

    it 'should find accepted answer' do
      expect(question.accepted_answer).to eq question.answers.last
    end

    it 'should change accepted answer' do
      answer_to_accept = question.answers.first
      question.accept_answer(answer_to_accept)
      expect(question.accepted_answer).to eq question.answers.first
      expect(question.answers.select(&:accepted)).to eq [answer_to_accept]
    end
  end

  context 'is author' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    it 'should be an author' do
      expect(question.author?(user)).to be_truthy
    end

  end

  context 'tags' do
    let!(:question) { create(:question, tags: create_list(:tag, 2)) }
    it 'should return tag names' do
      expect(question.tags_str).to eq('tag1 tag2')
    end

    it 'should add tags' do
      expect do
        question.tags_str = 't3 t4 t5'
      end.to change(Tag, :count).by(3)
      expect(question.tags.size).to eq(3)
    end
  end
end

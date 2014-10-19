#      save_screenshot('screen.png', :full => true)
feature 'Question' do

  scenario "don't see comment link on question" do
    visit question_path create(:question)
    within('#question') { expect(page).to_not have_link('add a comment') }
  end

  given(:user) { create(:user) }
  scenario 'add comment to question', js: true do
    signin_user(user)
    visit question_path create(:question)
    within('#question') do
      expect(page).to have_link('add a comment')
      click_on 'add a comment'
      fill_in 'Body', with: 'Question comment'
      click_on 'Add Your Comment'
      expect(page).to_not have_selector('form')
      within('.comments') { expect(page).to have_content('Question comment') }
    end
  end

  given(:enthusiast) { create(:user) }
  given(:expert) { create(:user) }
  given(:question_with_answers) do
    create(:question, user: enthusiast, answers: create_list(:answer, 3, user: expert))
  end

  scenario 'add comment to answer', js: true do
    signin_user(user)
    visit question_path question_with_answers
    within("#answer-#{question_with_answers.answers.first.id}") do
      expect(page).to have_link('add a comment')
      click_on 'add a comment'
      fill_in 'Body', with: 'Answer comment'
      click_on 'Add Your Comment'
      expect(page).to_not have_selector('form')
      within('.comments') { expect(page).to have_content('Answer comment') }
    end

  end

  scenario 'delete own comment from answer', js: true do
    signin_user(user)
    question_with_answers.answers.first.comments.create!(body: 'My comment', user: user)
    visit question_path question_with_answers
    within("#answer-#{question_with_answers.answers.first.id}") do
      expect(page).to have_link('delete')
      expect(page).to have_content('My comment')
      click_on 'delete'
      expect(page).to_not have_content('My comment')
    end
  end
  scenario 'edit own comment'

  scenario "on 'add a comment' click show add comment form"
  scenario 'check comment added to answer'
  scenario 'delete comment own'
  scenario 'edit own comment'

end

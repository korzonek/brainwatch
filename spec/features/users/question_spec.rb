feature 'Question' do

  # Scenario: See Ask Question link
  #   Given I am a visitor
  #   When I visit the home page
  #   Then I see "Ask Question"
  scenario 'See Ask Question link' do
    visit root_path
    expect(page).to have_link 'Ask Question'
  end

  scenario 'should be redirected to login page' do
    visit new_question_path
    expect(page.current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

  given(:user) { create(:user)}

  scenario 'ask question' do
    signin(user.email, user.password)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'My question'
    click_on 'Post Your Question'
    expect(page.current_path).to eq question_path(id: Question.last)
  end

  scenario 'list last 10 question' do
    create_list(:question, 11)
    visit questions_path
    expect(page).to have_selector('main li', count: 10)
  end

  scenario 'have a link to question' do
    create(:question)
    visit questions_path
    expect(page).to have_link('MyString')
  end

  scenario 'display question page' do
    visit question_path create(:question)
    expect(page).to have_content('MyString')
    expect(page).to have_selector('form')
  end

end
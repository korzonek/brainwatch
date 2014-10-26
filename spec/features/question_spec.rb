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

  given(:user) { create(:user) }

  scenario 'ask question' do
    signin(user.email, user.password)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'My question'
    click_on 'Post Your Question'
    expect(page.current_path).to eq question_path(id: Question.last)
  end

  scenario 'list last 10 question' do
    questions = create_list :question, 11
    visit questions_path
    expect(page).to have_content(questions.first.title, count: 10)
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

  scenario 'don\'t see comment link on question' do
    visit question_path create(:question)
    within('#question') { expect(page).to_not have_link('add a comment') }
  end

  scenario 'see comment link on question' do
    signin_user(user)
    visit question_path create(:question)
    within('#question') { expect(page).to have_link('add a comment') }
  end

  scenario 'check comment added to question', js: true do
    signin_user(user)
    visit question_path create(:question)
    click_on 'add a comment'
    within('#question') do
      fill_in 'Body', with: 'My comment text'
      click_on 'Add Your Comment'
      save_screenshot('screen.png', :full => true)
      expect(page).to have_content('My comment text')
    end
  end


  scenario 'Should add tags to question' do
    signin_user(user)
    visit new_question_path
    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'My question'
    fill_in 'Tags', with: 'ruby-on-rails active-record'
    click_on 'Post Your Question'
    expect(page).to have_link('ruby-on-rails')
    expect(page).to have_link('active-record')
  end

end

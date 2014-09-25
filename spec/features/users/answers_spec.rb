feature 'Answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:question_with_answers) { create(:question, answers: create_list(:answer, 3)) }

  scenario 'should be logged in to answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Post Your Answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

  scenario 'add answer to question', js: true do
    signin(user.email, user.password)
    visit question_path(question)
    fill_in 'Body', with: 'My New Answer '
    click_on 'Post Your Answer'
    expect(page.current_path).to eq question_path(id: Question.last)
    within('.answers') { expect(page).to have_content 'My New Answer' }
  end



  scenario 'should be able to accept the answer' do
    signin(user.email, user.password)
    visit question_path(question_with_answers)
    expect(page).to have_content(question_with_answers.answers.first.body, count: 3)
    #no accept if not an question owner
    #question owner should have three accept links for each question
    #selecting question displays check mark(ajax), removes previous check mark
    #should change remove previously made selection
    #
  end

end
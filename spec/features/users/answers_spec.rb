feature 'Answer' do
  given(:user) { create(:user) }

  scenario 'should be logged in to answer' do
    question = create(:question)
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Post Your Answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

  scenario 'add answer to question' do
    signin(user.email, user.password)
    question = create(:question)
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Post Your Answer'
    expect(page.current_path).to eq question_path(id: Question.last)
    expect(page).to have_content 'My Answer'
  end

end
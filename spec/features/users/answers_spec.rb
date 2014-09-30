feature 'Answer' do
  given(:enthusiast) { create(:user) }
  given(:expert) { create(:user) }
  given(:question) { create(:question, user: enthusiast) }
  given(:question_with_answers) { create(:question,user: enthusiast, answers: create_list(:answer, 3,user: expert)) }

  scenario 'should be logged in to answer' do
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Post Your Answer'
    expect(current_path).to eq new_user_session_path
    expect(page).to have_content I18n.t 'devise.failure.unauthenticated'
  end

  scenario 'add answer to question', js: true do
    signin_user(expert)
    visit question_path(question)
    fill_in 'Body', with: 'My New Answer '
    click_on 'Post Your Answer'
    expect(page.current_path).to eq question_path(id: Question.last)
    within('.answers') { expect(page).to have_content 'My New Answer' }
  end

  scenario 'should display accepted answer' do
    question_with_answers.answers.last.update_attribute(:accepted, true)
    visit question_path(question_with_answers)
    expect(page).to have_css('.glyphicon.glyphicon-ok.accepted', 1)
    within('.answers') { expect(page).to have_css('a.glyphicon.glyphicon-ok',2) }
  end

  scenario 'question author should be able to see accept links' do
    signin_user(enthusiast)
    visit question_path(question_with_answers)
    expect(page).to have_content(question_with_answers.answers.first.body, count: 3)
  end

  scenario 'non author should not see accept links' do

  end

  scenario 'should be able to accept the answer' do
    signin_user(enthusiast)
    visit question_path(question_with_answers)
    expect(page).to have_content(question_with_answers.answers.first.body, count: 3)
    #no accept if not an question owner
    #question owner should have three accept links for each question
    #selecting question displays check mark(ajax), removes previous check mark
    #should change remove previously made selection
  end
end
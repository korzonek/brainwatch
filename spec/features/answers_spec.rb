feature 'Answer' do
  given(:enthusiast) { create(:user) }
  given(:expert) { create(:user) }
  given(:question) { create(:question, user: enthusiast) }
  given(:question_with_answers) do
    create(:question, user: enthusiast, answers: create_list(:answer, 3, user: expert))
  end

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
  end

  scenario 'question author should be able to see accept links' do
    signin_user(enthusiast)
    visit question_path(question_with_answers)
    expect(page).to have_content(question_with_answers.answers.first.body, count: 3)
    within('.answers') { expect(page).to have_css('a span.glyphicon.glyphicon-ok', 2) }
  end

  scenario 'non author should not see accept links' do
    signin_user(expert)
    visit question_path(question_with_answers)
    within('.answers') { expect(page).to_not have_css('a span.glyphicon.glyphicon-ok', 2) }
  end

  scenario 'should be able to accept the answer', js: true do
    signin_user(enthusiast)
    # answer_to_select = question_with_answers.answers.first
    # answer_to_select.update(body: 'Select this Answer')
    visit question_path(question_with_answers)
    within('.answers') { expect(page).to have_css('a span.glyphicon.glyphicon-ok', 3) }
    page.all('a span.glyphicon.glyphicon-ok')[0].click
    within('.answers') { expect(page).to have_css('a span.glyphicon.glyphicon-ok', 2) }
  end
end

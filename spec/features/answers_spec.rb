feature 'Answer' do
  given(:enthusiast) { create(:user) }
  given(:expert) { create(:user) }
  given(:question) { create(:question, user: enthusiast) }
  given(:question_with_answers) do
    create(:question, user: enthusiast, answers: create_list(:answer, 3, user: expert))
  end

  scenario 'should be logged in to answer' do
    visit question_path(question)
    expect(page).to_not have_css('input')
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
    visit question_path(question_with_answers)
    within('.answers') { expect(page).to have_css('a span.glyphicon.glyphicon-ok', 3) }
    page.all('a span.glyphicon.glyphicon-ok')[0].click
    within('.answers') { expect(page).to have_css('a span.glyphicon.glyphicon-ok', 2) }
  end

  scenario 'as author should be able to edit answer', js: true do
    signin_user(expert)
    visit question_path(question_with_answers)
    answer_id = question_with_answers.answers.first.id
    within("#answer-#{answer_id}") do
      expect(page).to have_link('edit')
      click_on 'edit'
      fill_in 'Body', with: 'Corrected answer'
      click_on 'Post Your Answer'
      expect(page).to_not have_css('form')
      expect(page).to have_content('Corrected answer')
    end
  end

  scenario 'as not author should no be able to edit answer', js: true do
    signin_user(enthusiast)
    visit question_path(question_with_answers)
    answer_id = question_with_answers.answers.first.id
    within("#answer-#{answer_id}") do
      expect(page).to_not have_link('edit')
      expect(page).to_not have_link('delete')
    end
  end

  scenario 'as author should be able to delete answer', js: true do
    signin_user(expert)
    visit question_path(question_with_answers)
    answer_id = question_with_answers.answers.first.id
    within("#answer-#{answer_id}") do
      expect(page).to have_link('delete')
      click_on 'delete'
    end
    expect(page).to have_content(question_with_answers.answers.first.body, count: 2)
  end

end

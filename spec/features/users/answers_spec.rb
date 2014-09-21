feature 'Answer' do

  scenario 'add answer to question' do
    question = create(:question)
    visit question_path(question)
    fill_in 'Body', with: 'My Answer'
    click_on 'Post Your Answer'
    expect(page.current_path).to eq question_path(id: Question.last)
    expect(page).to have_content 'My Answer'
  end

end
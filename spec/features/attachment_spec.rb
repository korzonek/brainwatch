feature 'Attachment',%q{
  in order to provide details for question
  as enthusiast
  I like to attach files to question
} do

  given(:user) {create(:user)}
  given(:question) {create(:question)}

  scenario 'create question with attached files' do
    signin_user(user)
    visit new_question_path
    fill_in 'Title',with: 'Question Title'
    fill_in 'Body', with: 'Question Body'
    attach_file 'File', "#{Rails.root}/spec/features/attachment_spec.rb"
    click_on 'Post Your Question'
    expect(page).to have_link 'attachment_spec.rb', href: '/uploads/attachment/file/1/attachment_spec.rb'
  end

  scenario 'create answer with attached files' , js: true do
    signin_user(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer Body'
    attach_file 'File', "#{Rails.root}/spec/features/attachment_spec.rb"
    click_on 'Post Your Answer'
    expect(page).to have_link 'attachment_spec.rb', href: '/uploads/attachment/file/2/attachment_spec.rb'
  end
end
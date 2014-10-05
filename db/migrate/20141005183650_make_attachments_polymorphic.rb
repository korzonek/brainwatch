class MakeAttachmentsPolymorphic < ActiveRecord::Migration
  def change
    rename_column :attachments, :question_id, :attachable_id
    add_column :attachments, :attachable_type, :string
  end
end

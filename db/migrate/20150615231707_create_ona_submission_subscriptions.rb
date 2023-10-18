class CreateOnaSubmissionSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :ona_submission_subscriptions do |t|
      t.references :ona_submission
      t.references :follower, :polymorphic => true

      t.timestamps null: false
    end
  end
end

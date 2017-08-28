class CreatePullRequestEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :pull_request_events do |t|

      t.timestamps
    end
  end
end

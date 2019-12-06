class CreateOrganisers < ActiveRecord::Migration[5.2]
  def change
    create_table :organisers do |t|
			t.boolean :paid
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end

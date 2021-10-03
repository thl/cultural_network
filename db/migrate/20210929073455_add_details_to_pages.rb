class AddDetailsToPages < ActiveRecord::Migration[5.2]
  def change
    add_column :pages, :chapter, :integer
    add_column :pages, :tibetan_start_page, :string
    add_column :pages, :start_verse, :integer
    add_column :pages, :end_verse, :integer
    change_column :pages, :start_line, :string
    change_column :pages, :volume, :string
  end
end

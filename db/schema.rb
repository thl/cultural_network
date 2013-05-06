# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110628205752) do
  create_table "authors_descriptions", :id => false, :force => true do |t|
    t.column "author_id", :integer, :null => false
    t.column "description_id", :integer, :null => false
  end

  add_index "authors_descriptions", ["author_id", "description_id"], :name => "index_authors_descriptions_on_author_id_and_description_id", :unique => true

  create_table "authors_notes", :id => false, :force => true do |t|
    t.column "author_id", :integer, :null => false
    t.column "note_id", :integer, :null => false
  end

  add_index "authors_notes", ["author_id", "note_id"], :name => "index_authors_notes_on_author_id_and_note_id", :unique => true

  create_table "blurbs", :force => true do |t|
    t.column "code", :string
    t.column "title", :string
    t.column "content", :text
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "cached_category_counts", :force => true do |t|
    t.column "category_id", :integer, :null => false
    t.column "count", :integer, :null => false
    t.column "cache_updated_at", :timestamp, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "count_with_shapes", :integer, :null => false
  end

  add_index "cached_category_counts", ["category_id"], :name => "index_cached_category_counts_on_category_id", :unique => true

  create_table "cached_feature_names", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "view_id", :integer, :null => false
    t.column "feature_name_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "cached_feature_names", ["feature_id", "view_id"], :name => "index_cached_feature_names_on_feature_id_and_view_id", :unique => true

  create_table "cached_feature_relation_categories", :force => true do |t|
    t.column "feature_id", :integer
    t.column "related_feature_id", :integer
    t.column "category_id", :integer
    t.column "perspective_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "feature_relation_type_id", :integer
    t.column "feature_is_parent", :boolean
  end

  create_table "category_features", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "category_id", :integer, :null => false
    t.column "perspective_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "position", :integer, :default => 0, :null => false
    t.column "type", :string
    t.column "string_value", :string
    t.column "numeric_value", :integer
  end

  add_index "category_features", ["feature_id"], :name => "feature_object_types_feature_id_idx"
  add_index "category_features", ["category_id"], :name => "feature_object_types_object_type_id_idx"
  add_index "category_features", ["perspective_id"], :name => "feature_object_types_perspective_id_idx"

  create_table "citations", :force => true do |t|
    t.column "info_source_id", :integer
    t.column "citable_type", :string
    t.column "citable_id", :integer
    t.column "notes", :text
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "citations", ["citable_type", "citable_id"], :name => "citations_1_idx"
  add_index "citations", ["info_source_id"], :name => "citations_info_source_id_idx"

  create_table "complex_dates", :force => true do |t|
    t.column "year", :integer
    t.column "year_certainty_id", :integer
    t.column "season_id", :integer
    t.column "season_certainty_id", :integer
    t.column "month", :integer
    t.column "month_certainty_id", :integer
    t.column "day", :integer
    t.column "day_certainty_id", :integer
    t.column "day_of_week_id", :integer
    t.column "day_of_week_certainty_id", :integer
    t.column "time_of_day_id", :integer
    t.column "time_of_day_certainty_id", :integer
    t.column "hour", :integer
    t.column "hour_certainty_id", :integer
    t.column "minute", :integer
    t.column "minute_certainty_id", :integer
    t.column "animal_id", :integer
    t.column "animal_certainty_id", :integer
    t.column "calendrical_id", :integer
    t.column "calendrical_certainty_id", :integer
    t.column "element_certainty_id", :integer
    t.column "element_id", :integer
    t.column "gender_id", :integer
    t.column "gender_certainty_id", :integer
    t.column "intercalary_month_id", :integer
    t.column "intercalary_day_id", :integer
    t.column "rabjung_id", :integer
    t.column "rabjung_certainty_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "year_end", :integer
    t.column "season_end_id", :integer
    t.column "month_end", :integer
    t.column "day_end", :integer
    t.column "day_of_week_end_id", :integer
    t.column "time_of_day_end_id", :integer
    t.column "hour_end", :integer
    t.column "minute_end", :integer
    t.column "rabjung_end_id", :integer
    t.column "intercalary_month_end_id", :integer
    t.column "intercalary_day_end_id", :integer
  end

  create_table "cumulative_category_feature_associations", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "category_id", :integer, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "cumulative_category_feature_associations", ["feature_id", "category_id"], :name => "by_category_feature", :unique => true

  create_table "descriptions", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "content", :text, :null => false
    t.column "is_primary", :boolean, :default => false, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "title", :string
    t.column "source_url", :string
  end

  create_table "feature_geo_codes", :force => true do |t|
    t.column "feature_id", :integer
    t.column "geo_code_type_id", :integer
    t.column "timespan_id", :integer
    t.column "geo_code_value", :string
    t.column "notes", :text
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "feature_name_relations", :force => true do |t|
    t.column "child_node_id", :integer, :null => false
    t.column "parent_node_id", :integer, :null => false
    t.column "ancestor_ids", :string
    t.column "is_phonetic", :integer
    t.column "is_orthographic", :integer
    t.column "is_translation", :integer
    t.column "is_alt_spelling", :integer
    t.column "phonetic_system_id", :integer
    t.column "orthographic_system_id", :integer
    t.column "alt_spelling_system_id", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "feature_name_relations", ["child_node_id"], :name => "feature_name_relations_child_node_id_idx"
  add_index "feature_name_relations", ["parent_node_id"], :name => "feature_name_relations_parent_node_id_idx"

  create_table "feature_names", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "name", :string, :null => false
    t.column "feature_name_type_id", :integer
    t.column "ancestor_ids", :string
    t.column "position", :integer, :default => 0
    t.column "etymology", :text
    t.column "writing_system_id", :integer
    t.column "language_id", :integer, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "is_primary_for_romanization", :boolean, :default => false
  end

  add_index "feature_names", ["ancestor_ids"], :name => "feature_names_ancestor_ids_idx"
  add_index "feature_names", ["feature_id"], :name => "feature_names_feature_id_idx"
  add_index "feature_names", ["name"], :name => "feature_names_name_idx"

  create_table "feature_relation_types", :force => true do |t|
    t.column "is_symmetric", :boolean
    t.column "label", :string, :null => false
    t.column "asymmetric_label", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "code", :string, :null => false
    t.column "is_hierarchical", :boolean, :default => false, :null => false
    t.column "asymmetric_code", :string
  end

  create_table "feature_relations", :force => true do |t|
    t.column "child_node_id", :integer, :null => false
    t.column "parent_node_id", :integer, :null => false
    t.column "ancestor_ids", :string
    t.column "notes", :text
    t.column "role", :string, :limit => 20
    t.column "perspective_id", :integer, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "feature_relation_type_id", :integer, :null => false
  end

  add_index "feature_relations", ["ancestor_ids"], :name => "feature_relations_ancestor_ids_idx"
  add_index "feature_relations", ["child_node_id"], :name => "feature_relations_child_node_id_idx"
  add_index "feature_relations", ["parent_node_id"], :name => "feature_relations_parent_node_id_idx"
  add_index "feature_relations", ["perspective_id"], :name => "feature_relations_perspective_id_idx"
  add_index "feature_relations", ["role"], :name => "feature_relations_role_idx"

  create_table "features", :force => true do |t|
    t.column "is_public", :integer
    t.column "position", :integer, :default => 0
    t.column "ancestor_ids", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "old_pid", :string
    t.column "is_blank", :boolean, :default => false, :null => false
    t.column "fid", :integer, :null => false
    t.column "is_name_position_overriden", :boolean, :default => false, :null => false
  end

  add_index "features", ["ancestor_ids"], :name => "features_ancestor_ids_idx"
  add_index "features", ["fid"], :name => "features_fid", :unique => true
  add_index "features", ["is_public"], :name => "features_is_public_idx"

  create_table "info_sources", :force => true do |t|
    t.column "code", :string, :null => false
    t.column "title", :string
    t.column "agent", :string
    t.column "date_published", :date
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "info_sources", ["code"], :name => "info_sources_code_key", :unique => true
  
  create_table "note_titles", :force => true do |t|
    t.column "title", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "notes", :force => true do |t|
    t.column "notable_type", :string
    t.column "notable_id", :integer
    t.column "note_title_id", :integer
    t.column "custom_note_title", :string
    t.column "content", :text
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "association_type", :string
    t.column "is_public", :boolean, :default => true
  end

  create_table "pages", :force => true do |t|
    t.column "citation_id", :integer
    t.column "volume", :integer
    t.column "start_page", :integer
    t.column "start_line", :integer
    t.column "end_page", :integer
    t.column "end_line", :integer
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  create_table "perspectives", :force => true do |t|
    t.column "name", :string
    t.column "code", :string
    t.column "description", :text
    t.column "notes", :text
    t.column "is_public", :boolean, :default => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "perspectives", ["code"], :name => "index_perspectives_on_code"

  create_table "simple_props", :force => true do |t|
    t.column "name", :string
    t.column "code", :string
    t.column "description", :text
    t.column "notes", :text
    t.column "type", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "simple_props", ["code"], :name => "simple_props_code_idx"
  add_index "simple_props", ["type"], :name => "simple_props_type_idx"

  create_table "time_units", :force => true do |t|
    t.column "date_id", :integer
    t.column "start_date_id", :integer
    t.column "end_date_id", :integer
    t.column "calendar_id", :integer
    t.column "is_range", :boolean
    t.column "dateable_id", :integer
    t.column "dateable_type", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "frequency_id", :integer
  end

  create_table "timespans", :force => true do |t|
    t.column "start_date", :date
    t.column "end_date", :date
    t.column "start_date_fuzz", :integer
    t.column "end_date_fuzz", :integer
    t.column "is_current", :integer
    t.column "dateable_id", :integer
    t.column "dateable_type", :string
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "timespans", ["dateable_id", "dateable_type"], :name => "timespans_1_idx"
  add_index "timespans", ["end_date"], :name => "timespans_end_date_idx"
  add_index "timespans", ["start_date"], :name => "timespans_start_date_idx"

  create_table "users", :force => true do |t|
    t.column "login", :string, :null => false
    t.column "email", :string, :null => false
    t.column "person_id", :integer
    t.column "crypted_password", :string, :limit => 40, :null => false
    t.column "salt", :string, :limit => 40
    t.column "remember_token", :string
    t.column "remember_token_expires_at", :timestamp
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
    t.column "identity_url", :string
    t.column "fullname", :string
  end

  create_table "xml_documents", :force => true do |t|
    t.column "feature_id", :integer, :null => false
    t.column "document", :text, :null => false
    t.column "created_at", :timestamp
    t.column "updated_at", :timestamp
  end

  add_index "xml_documents", ["feature_id"], :name => "xml_documents_feature_id_idx"
end

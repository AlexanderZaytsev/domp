<% module_namespacing do -%>
class Create<%= class_name %>Authentications < ActiveRecord::Migration
  def change
    create_table "<%= class_name.downcase %>_authentications", :force => true do |t|
      t.integer  "<%= class_name.downcase %>_id"
      t.integer  "authentication_provider_id"
      t.string   "uid"
      t.string   "token"
      t.datetime "token_expires_at"
      t.text     "params"
      t.datetime "created_at",                 :null => false
      t.datetime "updated_at",                 :null => false
    end
    add_index "<%= class_name.downcase %>_authentications", ["authentication_provider_id"], :name => "index_<%= class_name.downcase %>_authentications_on_authentication_provider_id"
    add_index "<%= class_name.downcase %>_authentications", ["<%= class_name.downcase %>_id"], :name => "index_<%= class_name.downcase %>_authentications_on_user_id"
  end
end
<% end -%>


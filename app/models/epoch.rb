class Epoch < ActiveRecord::Base
 validates_presence_of :name

  set_table_name "epochs"
end

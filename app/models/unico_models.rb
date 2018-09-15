class UnicoModels < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :unico
end

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # コールバックスキップに使用(seed作成時に作動しないようにする)
  def seeding?
    defined?($skip_callbacks) && $skip_callbacks
  end
end
class Post < ActiveRecord::Base
  ##############################################################################
  # validations
  ##############################################################################

  validates_presence_of :name
end
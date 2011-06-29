require 'test_helper'

class PostTest < ActiveRecord::TestCase
  def setup
    @post = Factory.build :post
  end

  def test_factory
    assert @post.valid?, @post.errors.full_messages.inspect
  end
end

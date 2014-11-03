# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

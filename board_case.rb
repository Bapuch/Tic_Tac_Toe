# frozen_string_literal: true

# This class represents one case of the board
class BoardCase
  attr_accessor :case
  # it only needs to be initialize as empty and the value of "case" can be updated afterwards
  def initialize
    @case = " "
  end
end

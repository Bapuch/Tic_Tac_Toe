# frozen_string_literal: true

# This class represents a player
class Player
  attr_accessor :name, :mark, :status

  # It is initialized with at least a name and a mark (X/O), the status is set empty at first
  def initialize(name, mark)
    @name = name
    @mark = mark
    @status = ""
  end
end

# frozen_string_literal: true

require 'colorize'
require 'pry'

# *****************************************************************************************
# This class represents a player
# *****************************************************************************************
class Player
  attr_accessor :name, :mark, :status

  # It is initialized with at least a name and a mark (X/O), the status is set empty at first
  def initialize(name, mark)
    @name = name
    @mark = mark
    @status = ""
  end
end

# *****************************************************************************************
# This class represents one case of the board
# *****************************************************************************************
class BoardCase
  attr_accessor :case
  # it only needs to be initialize as empty and the value of "case" can be updated afterwards
  def initialize
    @case = " "
  end
end

# *****************************************************************************************
# This class represents the board of the game. It creates 9 instances of BoardCase
# *****************************************************************************************
class Board
  attr_accessor :case_a1, :case_a2, :case_a3, :case_b1, :case_b2
  attr_accessor :case_b3, :case_c1, :case_c2, :case_c3, :board

  # This method initializes the the board by creating 9 cases (instances of BoardCase)
  def initialize
    @case_a1 = BoardCase.new
    @case_a2 = BoardCase.new
    @case_a3 = BoardCase.new
    @case_b1 = BoardCase.new
    @case_b2 = BoardCase.new
    @case_b3 = BoardCase.new
    @case_c1 = BoardCase.new
    @case_c2 = BoardCase.new
    @case_c3 = BoardCase.new
    # @board = [[@case_a1.case, @case_b1.case, @case_c1.case], [@case_a2.case, @case_b2.case, @case_c2.case], [@case_a3.case, @case_b3.case, @case_c3.case]]
  end

  # This method draws the board at its current state
  def draw_board
    # first, it updates the @board variables to get the current state of each case
    @board = [[@case_a1.case, @case_b1.case, @case_c1.case], [@case_a2.case, @case_b2.case, @case_c2.case], [@case_a3.case, @case_b3.case, @case_c3.case]]

    # then prints beautifully the board
    print "\n" + "=".red * 33 + "\n"
    print "||    ".red + " | " + "  A   |   B   |   C  " + " ||".red + "\n"
    print "||".red + "_____" + "|_" + "______|_______|_______" + "||".red + "\n"
    print "||    ".red + " | " + "                      ||".red
    print "\n" + "||".red + "  1  |   #{@board[0][0]}   |   #{@board[0][1]}   |   #{@board[0][2]}  " + " ||".red + "\n"
    print "||".red + "_" * 5 + "| " + " ___     ___     ___" + "  ||".red + "\n"
    print "||    ".red + " | " + "                      ||".red
    print "\n" + "||".red + "  2  |   #{@board[1][0]}   |   #{@board[1][1]}   |   #{@board[1][2]}  " + " ||".red + "\n"
    print "||".red + "_" * 5 + "| " + " ___     ___     ___" + "  ||".red + "\n"
    print "||    ".red + " | " + "                      ||".red
    print "\n" + "||".red + "  3  |   #{@board[2][0]}   |   #{@board[2][1]}   |   #{@board[2][2]}  " + " ||".red + "\n"
    print "=".red * 33 + "\n"
  end
end

# *****************************************************************************************
# This class is the game. It calls creates 2 instances of players and 1 instance of Board
# *****************************************************************************************
class Game
  attr_accessor :player1, :player2, :board, :win_combo, :new_case, :selected_case

  # This where it all happens
  def initialize
    # Prompts for players name and creates instance of Player accordingly
    puts "What's the name on Player #1 ?"
    print "> "
    @player1 = Player.new(gets.chomp, 'X')
    puts "What's the name on Player #2 ?"
    print "> "
    @player2 = Player.new(gets.chomp, 'O')
    # Now the game can start. Let's get the players attention and display once the empty board
    launch_game
    # Notice which players plays with Xs and which plays with Os
    puts "\n#{@player1.name} you play with '#{@player1.mark}' and #{@player2.name} you play with '#{@player2.mark}'"
    # and party !
    party
  end

  # fill the hash with all the possible winning combinasion
  def initialize_win_combo
    @win_combo = {}
    @win_combo[:combo_l1] = [@board.case_a1.case, @board.case_b1.case, @board.case_c1.case]
    @win_combo[:combo_l2] = [@board.case_a2.case, @board.case_b2.case, @board.case_c2.case]
    @win_combo[:combo_l3] = [@board.case_a3.case, @board.case_b3.case, @board.case_c3.case]
    @win_combo[:combo_c1] = [@board.case_a1.case, @board.case_a2.case, @board.case_a3.case]
    @win_combo[:combo_c2] = [@board.case_b1.case, @board.case_b2.case, @board.case_b3.case]
    @win_combo[:combo_c3] = [@board.case_c1.case, @board.case_c2.case, @board.case_c3.case]
    @win_combo[:combo_d1] = [@board.case_a1.case, @board.case_b2.case, @board.case_c3.case]
    @win_combo[:combo_d2] = [@board.case_a3.case, @board.case_b2.case, @board.case_c1.case]
  end

  # this methods creates the instance of the Board and display it once empty
  def launch_game
    print "Welcome to the TIC TAC TOE board game #{@player1.name} and #{@player2.name}!\nREADY\n(tic)"
    3.times { sleep(0.5); print "." }
    print "\nSET\n(tac)"
    3.times { sleep(0.5); print "." }
    puts "\n(TOE) ! LET'S PLAY !! "
    sleep(1)
    @board = Board.new
    @board.draw_board
  end

  # This method simply loops for each turn and check if there's any winner for each turn or if the party is over
  def party
    # set a few local variables
    last_player = @player2
    wehaveawinner = ""
    partyover = false
    # loop for each turn
    while wehaveawinner.empty? && !partyover
      last_player = last_player == @player2 ? @player1 : @player2
      next_turn(last_player.name, last_player.mark)
      # Draw the board as it is after the last action for each turn
      @board.draw_board
      # Check if there's a winner
      wehaveawinner = win?(last_player.mark)
      # check if the party is over
      partyover = party_over?
    end

    # Party is over. We can now display the final message
    if !wehaveawinner.empty?
      # In this case we have a WINNER. We can update her/his status and congratulate her/him
      last_player.status = "WINNER"
      print "\n \\(ᵔᵕᵔ)/".cyan.bold + "  W".blue + "E".magenta + " H".cyan + "A".yellow + "V".red + "E".blue + " A".magenta
      print " W".cyan + "I".yellow + "N".blue + "N".magenta + "E".cyan + "R".yellow + " !!!!".yellow + "  \\(ᵔᵕᵔ)/".cyan.bold
      str1 = "\n" + "    C".blue + "O".magenta + "N".cyan + "G".yellow + "R".blue + "A".magenta + "T".cyan + "U".yellow + "L".blue
      str1 += "A".magenta + "T".cyan + "I".yellow + "O".blue + "N".magenta + "S ".cyan + last_player.name.upcase.green + " ( ⌐■ _■ )"
      puts str1.bold
    elsif partyover
      # It's a draw! Let's shame both players
      puts " AAaaaaw, YOU BOTH SUCK !! ¯\_(ツ)_/¯ \n But practive makes perfect, sooo..PRACTICE !".red.bold
    end
  end

  # This method will prompt the player for her/his next action and update the boardcase accordingly
  def next_turn(player, mark)
    # prompt player to select a new case to mark
    print "\n#{player} where do you want to place your '#{mark}' ? (ex: A1 or B3) > "
    @selected_case = gets.chomp.upcase
    # check if the case entered is valid
    valid_case?(player)
    # check if the case is available (empty) and map to it to the corresponding case
    empty_case?(player)
    # Update the selected case with its new value
    @new_case.case = mark
    # Confirm the the last action
    print "\n> New '#{mark}' set on #{@selected_case} by #{player} :"
  end

  # This method checks if the case entered by the player is valid. It is not case sensitive
  def valid_case?(player)
    # loop until the selected case is valid !
    while !@selected_case.match?(/A1|A2|A3|B1|B2|B3|C1|C2|C3/)
      print "Sorry #{player} this is not a valid case, please try again > "
      @selected_case = gets.chomp.upcase
    end
    true
  end

  # This method maps the selected case and checks if it is available
  def empty_case?(player)
    map_case(@selected_case)
    # loop until the selected case is available!
    until @new_case.case == " "
      print "Sorry #{player} but this case is already taken, please try another one > "
      @selected_case = gets.chomp.upcase
      # check again if the new selected case is valid
      valid_case?(player)
      # map the new selected case
      map_case(@selected_case)
    end
    true
  end

  # This method map the selected_case with the corresponding instance variable of the board
  # And stock it in @new_case
  def map_case(value)
    case value
    when 'A1'
      @new_case = @board.case_a1
    when 'A2'
      @new_case = @board.case_a2
    when 'A3'
      @new_case = @board.case_a3
    when 'B1'
      @new_case = @board.case_b1
    when 'B2'
      @new_case = @board.case_b2
    when 'B3'
      @new_case = @board.case_b3
    when 'C1'
      @new_case = @board.case_c1
    when 'C2'
      @new_case = @board.case_c2
    when 'C3'
      @new_case = @board.case_c3
    end
  end

  # This method checks if the player has won this turn
  def win?(mark)
    # first we need to update the hash containing all the winning combinason with the last values of the board
    initialize_win_combo
    rslt = ""
    @win_combo.each do |_k, v|
      next unless v[0] == mark && v[1] == mark && v[2] == mark
      rslt = v
      break
    end
    rslt
  end

  # this method checks if the party is over
  # by checkign if there's any empty case left
  def party_over?
    rslt = true
    @board.board.flatten.each { |c| rslt = false if c == " " }
    rslt
  end
end

# run the game
Game.new

require './grid.rb'

class Game
  attr_accessor :grid, :total_cost

  def initialize(grid_size:)
    @grid = Grid.new(size: grid_size)
    @players = []
    @players_state = {}
    @total_cost = 0
    @timer = 0
  end

  def add_player(player)
    @players << player
    @players_state[player] = { position: nil }
  end

  def start
    puts "Game started! Timer is #{timer}"

    until finished?
      puts "Epoch #{@timer}"

      @players.each do |player|
        process_player_move(player)
      end

      @timer += 1
    end

    display_results
    game_summary
  end

  private

  attr_accessor :players, :players_state

  MAX_TIME = 1_000_000

  def process_player_move(player)
    current_position = @players_state[player][:position]
    new_position = player.next_point(time: @timer)

    if current_position.nil?
      initialize_player_position(player, new_position)
    elsif @grid.is_valid_move?(from: current_position, to: new_position)
      execute_player_move(player, new_position)
    else
      puts "Invalid move for #{player.name}. Skipping..."
    end
  end

  def initialize_player_position(player, new_position)
    @players_state[player][:position] = new_position
    @grid.visit(new_position)
  end

  def execute_player_move(player, new_position)
    @grid.visit(new_position)
    @total_cost += @grid.move_cost(from: @players_state[player][:position], to: new_position)
    @players_state[player][:position] = new_position
  end

  def display_results
    puts "Game finished! Final time is #{timer} and total cost is #{@total_cost}"
  end

  def game_summary
    {
      all_visited: @grid.all_visited?,
      total_time: @timer,
      total_cost: @total_cost
    }
  end

  def finished?
    @timer > MAX_TIME || @grid.all_visited?
  end

  def timer
    @timer
  end
end

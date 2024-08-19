require './base_player.rb'
require 'set'

class YourPlayer < BasePlayer
  def initialize(game:, name:)
    super
    @visited = Set.new
    @path = []
    @current_position = { row: 0, col: 0 }
  end

  def next_point(time:)
    if @path.any?
      @current_position = @path.pop
    else
      perform_dfs(@current_position)
      @current_position = @path.pop || @current_position
    end
    @current_position
  end

  private

  def perform_dfs(start_point)
    stack = [start_point]
    while stack.any?
      point = stack.pop
      next if @visited.include?(point)

      @visited.add(point)
      @path << point

      neighbors(point).each do |neighbor|
        stack.push(neighbor) unless @visited.include?(neighbor)
      end
    end
  end

  def neighbors(point)
    row, col = point[:row], point[:col]
    neighbors = []

    [[row-1, col], [row+1, col], [row, col-1], [row, col+1]].each do |r, c|
      next unless r.between?(0, game.grid.max_row) && c.between?(0, game.grid.max_col)
      neighbors << { row: r, col: c }
    end

    neighbors
  end
end

class Grid
  attr_accessor :visited, :edges, :size

  def initialize(size:)
    @size = size
    @visited = {}
    init_grid
  end

  def visit(point)
    raise "Point #{point} is not a valid point" unless valid_point?(point)

    visited[point] = true
  end

  def all_visited?
    visited.values.count(true) == size * size
  end

  def is_valid_move?(from:, to:)
    edges[from] && edges[from][to]
  end

  def move_cost(from:, to:)
    raise 'Invalid move' unless is_valid_move?(from: from, to: to)

    edges[from][to]
  end

  def max_col
    size - 1
  end

  def max_row
    size - 1
  end

  private

  attr_accessor :size

  def init_grid
    @edges = {}
    moves = define_moves

    (0...size).each do |row|
      (0...size).each do |col|
        from = { row: row, col: col }

        initialize_edges(from)

        moves.each_key do |x_direction|
          moves[x_direction].each do |y_direction|
            neighbour_x, neighbour_y = row + x_direction, col + y_direction
            next unless valid_position?(neighbour_x, neighbour_y)

            to = { row: neighbour_x, col: neighbour_y }

            next if edge_exists?(from, to)

            create_edge(from, to, rand(1..10))
          end
        end
      end
    end
  end

  def define_moves
    {
      -1 => [0],
      0 => [-1, 1],
      1 => [0]
    }
  end

  def valid_position?(x, y)
    x.between?(0, size - 1) && y.between?(0, size - 1)
  end

  def valid_point?(point)
    point.is_a?(Hash) && point.key?(:row) && point.key?(:col)
  end

  def initialize_edges(from)
    @edges[from] ||= {}
    @edges[from][from] = 0
    @visited[from] = false
  end

  def edge_exists?(from, to)
    edges[from] && edges[from][to] || edges[to] && edges[to][from]
  end

  def create_edge(from, to, weight)
    edges[to] ||= {}
    edges[from][to] = weight
    edges[to][from] = weight

    puts "Building edge (#{from[:row]}, #{from[:col]}) -> (#{to[:row]}, #{to[:col]}) = #{weight}"
  end
end

exit if Object.const_defined?(:Ocra)

require 'ruby2d'

set(title: "Ruby's Game of Life", width: 600, height: 400, fps_cap: 60)

WIDTH = Window.width
HEIGHT = Window.height
SIZE = 10
COLS = WIDTH / SIZE
ROWS = HEIGHT / SIZE

BLACK_COLOR = [0.0, 0.0, 0.0, 1].freeze
DEAD_COLOR = [0.1, 0.14, 0.14, 1].freeze

grid = Array.new(ROWS * COLS).map! { |_| 0 }
previous_grid = Array.new(ROWS * COLS).map! { |_| 0 }

paused = true
paused_text = Text.new('PAUSED')

selected = :cell
selected_text = Text.new('', size: 12)
SHAPES = %i[cell block blinker glider gosper_glider_gun].freeze

puts '* CONTROLS:'
puts '  Left Mouse Button - Draws a cell'
puts '  1..5 - Select a pattern to be drawn (see below)'
puts '  P - Pauses the game'
puts '  R - Returns the grid to the previous state (i.e. before the last cell was drawn)'
puts '  C - Clears the screen'
puts '  ESC - Exit the game'
puts
puts '* PATTERNS:'
puts '  1 - Cell'
puts '  2 - Block'
puts '  3 - Blinker'
puts '  4 - Glider'
puts '  5 - Gosper glider gun'
puts

def index(x, y)
  x + y * COLS
end

def count_neighbors(grid, i)
  x = i % COLS
  y = i / COLS
  sum = 0
  (-1..1).each do |c|
    (-1..1).each do |r|
      next if (x + c).negative? || ((x + c) >= COLS) || (y + r).negative? || ((y + r) >= ROWS)

      col = (x + c) % COLS
      row = (y + r) % ROWS
      n = index(col, row)
      sum += grid[n]
    end
  end
  sum -= grid[i]
end

on :key_down do |event|
  case event.key
  when 'escape'
    close
  when 'p'
    paused = paused ? false : true
  when 'r'
    paused = true
    grid = previous_grid
  when 'c'
    grid.map! { |_| 0 }
  when '1', '2', '3', '4', '5'
    selected = SHAPES[event.key.to_i - 1]
  end
end

on :mouse_down do |event|
  case event.button
  when :left
    x = Window.mouse_x / SIZE
    y = Window.mouse_y / SIZE
    i = index(x, y)
    # I could use a lookup table, but this is probably more efficient (although less readable)
    case selected
    when :cell
      grid[i] = grid[i].zero? ? 1 : 0
    when :block
      grid[i] = 1
      grid[index(x + 1, y)] = 1
      grid[index(x, y + 1)] = 1
      grid[index(x + 1, y + 1)] = 1
    when :blinker
      grid[i] = 1
      grid[index(x - 1, y)] = 1
      grid[index(x + 1, y)] = 1
    when :glider
      grid[i] = 1
      grid[index(x + 1, y + 1)] = 1
      grid[index(x + 2, y - 1)] = 1
      grid[index(x + 2, y)] = 1
      grid[index(x + 2, y + 1)] = 1
    when :gosper_glider_gun
      grid[i] = 1
      grid[index(x + 1, y)] = 1
      grid[index(x, y + 1)] = 1
      grid[index(x + 1, y + 1)] = 1

      grid[index(x + 10, y)] = 1
      grid[index(x + 10, y + 1)] = 1
      grid[index(x + 10, y + 2)] = 1
      grid[index(x + 11, y - 1)] = 1
      grid[index(x + 12, y - 2)] = 1
      grid[index(x + 13, y - 2)] = 1
      grid[index(x + 11, y + 3)] = 1
      grid[index(x + 12, y + 4)] = 1
      grid[index(x + 13, y + 4)] = 1
      grid[index(x + 15, y - 1)] = 1
      grid[index(x + 16, y)] = 1
      grid[index(x + 14, y + 1)] = 1
      grid[index(x + 16, y + 1)] = 1
      grid[index(x + 17, y + 1)] = 1
      grid[index(x + 16, y + 2)] = 1
      grid[index(x + 15, y + 3)] = 1

      grid[index(x + 20, y)] = 1
      grid[index(x + 21, y)] = 1
      grid[index(x + 20, y - 1)] = 1
      grid[index(x + 21, y - 1)] = 1
      grid[index(x + 20, y - 2)] = 1
      grid[index(x + 21, y - 2)] = 1
      grid[index(x + 22, y - 3)] = 1
      grid[index(x + 24, y - 3)] = 1
      grid[index(x + 24, y - 4)] = 1
      grid[index(x + 22, y + 1)] = 1
      grid[index(x + 24, y + 1)] = 1
      grid[index(x + 24, y + 2)] = 1

      grid[index(x + 34, y - 1)] = 1
      grid[index(x + 35, y - 1)] = 1
      grid[index(x + 34, y - 2)] = 1
      grid[index(x + 35, y - 2)] = 1
    end
    previous_grid = grid
  end
end

render do
  clear

  COLS.times do |j|
    ROWS.times do |i|
      x = j * SIZE
      y = i * SIZE
      Square.draw(x: x, y: y, size: SIZE, color: [BLACK_COLOR, BLACK_COLOR, BLACK_COLOR, BLACK_COLOR])
      if grid[index(j, i)] == 1
        color = case count_neighbors(grid, index(j, i))
                when 0
                  [0.47, 0.75, 0.19, 1.0]
                when 1
                  [0.66, 0.85, 0.28, 1.0]
                when 2
                  [0.94, 0.85, 0.38, 1.0]
                when 3
                  [1.0, 0.75, 0.09, 1.0]
                else
                  [0.94, 0.56, 0.0, 1.0]
                end
        Square.draw(x: x + 1, y: y + 1, size: SIZE - 2, color: [color, color, color, color])
      else
        Square.draw(x: x + 1, y: y + 1, size: SIZE - 2, color: [DEAD_COLOR, DEAD_COLOR, DEAD_COLOR, DEAD_COLOR])
      end
    end
  end

  if paused
    # FIXME: (bug?) Ruby2D won't allow me to pass the size as an argument to `draw` anymore for some reason.
    # This will have to do for now.
    paused_text.size = 31
    paused_text.draw(x: (WIDTH / 2) - (paused_text.width / 2), y: (HEIGHT / 2) - (paused_text.height / 2), rotate: 0, color: [0, 0, 0, 1])
    paused_text.size = 30
    paused_text.draw(x: (WIDTH / 2) - (paused_text.width / 2), y: (HEIGHT / 2) - (paused_text.height / 2), rotate: 0, color: [1, 0.69, 0, 1])
  end

  selected_text.text = "#{selected.to_s.capitalize.gsub('_', ' ')} selected"
  selected_text.draw(x: 3, y: 2, rotate: 0, color: [1, 1, 1, 0.5])
end

update do
  unless paused
    next_gen = []

    (COLS * ROWS).times do |i|
      state = grid[i]
      n = count_neighbors(grid, i)
      next_gen[i] = if state.zero? && n == 3
                      1
                    elsif state == 1 && (n < 2 || n > 3)
                      0
                    else
                      state
                    end
    end

    grid = next_gen
  end
end

show

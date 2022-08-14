exit if Object.const_defined?(:Ocra)

require 'ruby2d'

set(title: "Conway's Game of Life", width: 600, height: 400)

WIDTH = Window.width
HEIGHT = Window.height
SIZE = 10
COLS = WIDTH / SIZE
ROWS = HEIGHT / SIZE

grid = Array.new(ROWS * COLS).map! { |_| 0 }
previous_grid = Array.new(ROWS * COLS).map! { |_| 0 }
paused = true
paused_text = Text.new('PAUSED')

puts '* CONTROLS:'
puts '  Left Mouse Button - Draws a cell'
puts '  P - Pauses the game'
puts '  R - Resets the grid to the previous state (i.e. before the last cell was drawn)'
puts '  C - Clears the screen'
puts '  ESC - Exit the game'

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
  end
end

on :mouse_down do |event|
  case event.button
  when :left
    x = Window.mouse_x / SIZE
    y = Window.mouse_y / SIZE
    i = index(x, y)
    grid[i] = grid[i].zero? ? 1 : 0
    previous_grid = grid
  end
end

render do
  COLS.times do |j|
    ROWS.times do |i|
      x = j * SIZE
      y = i * SIZE
      if grid[index(j, i)] == 1
        color = case count_neighbors(grid, index(j, i))
                when 0
                  [0.2, 0.263, 0.478, 1.0]
                when 1
                  [0.251, 0.506, 0.337, 1.0]
                when 2
                  [0.576, 0.639, 0.11, 1.0]
                when 3
                  [0.839, 0.667, 0.149, 1.0]
                else
                  [0.741, 0.165, 0.2, 1.0]
                end
        Square.draw(x: x, y: y, size: SIZE, color: [color, color, color, color])
      else
        Square.draw(
          x: x, y: y, size: SIZE, color: [
            [0.08, 0.12, 0.1, 1],
            [0.08, 0.12, 0.1, 1],
            [0.08, 0.12, 0.1, 1],
            [0.08, 0.12, 0.1, 1]
          ]
        )
      end
    end
  end

  paused_text.draw(x: (WIDTH / 2) - 50, y: (HEIGHT / 2) - 15, rotate: 0, size: 31, color: [0, 0, 0, 1]) if paused
  paused_text.draw(x: (WIDTH / 2) - 50, y: (HEIGHT / 2) - 15, rotate: 0, size: 30, color: [1, 0.69, 0, 1]) if paused
end

update do
  clear

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

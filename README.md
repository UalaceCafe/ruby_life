![ruby_life_logo](assets/logo.png)

[![Ko-Fi](https://img.shields.io/static/v1?message=Buy%20me%20a%20coffee&logo=kofi&labelColor=ff5e5b&color=434B57&logoColor=white&label=%20)](https://ko-fi.com/ualacecafe)

## What's Ruby's Life

Ruby's Life is a recreation of the well-known cellular automaton [_Conway's Game of Life_](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) written in Ruby using the [Ruby2D gem](https://github.com/ruby2d/ruby2d).

## How to Play

With [Ruby2D](https://github.com/ruby2d/ruby2d) installed, run `ruby life.rb`

| Control           | Description                                                                  |
|:------------------|:-----------------------------------------------------------------------------|
| Left Mouse Button | Adds or removes a cell                                                       |
| 1..5              | Select a pattern to be drawn (see the next section)                                |
| P                 | Pauses the game                                                              |
| R                 | Returns the grid to the previous state (i.e. before the last cell was added) |
| C                 | Clears the screen                                                            |                                                            
| ESC               | Exit the game                                                                |

## Patterns

The numerical keys are used to choose a certain cell pattern to be placed. Currently, the following patterns are available:

| Name               | Key |                                                                      Pattern                                                                       |
|:-------------------|:---:|:--------------------------------------------------------------------------------------------------------------------------------------------------:|
| Cell               |  1  |                                                                         -                                                                          |
| Block              |  2  | ![block](https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/Game_of_life_block_with_border.svg/99px-Game_of_life_block_with_border.svg.png) |
| Blinker            |  3  |                              ![blinker](https://upload.wikimedia.org/wikipedia/commons/9/95/Game_of_life_blinker.gif)                              |  
| Glider             |  4  |                          ![glider](https://upload.wikimedia.org/wikipedia/commons/f/f2/Game_of_life_animated_glider.gif)                           |
| Gosper glider gun  |  5  | ![gosper_glider_gun](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Game_of_life_glider_gun.svg/610px-Game_of_life_glider_gun.svg.png)  |

## Rules

This implementation follows the [standard set of rules](https://en.wikipedia.org/wiki/Conway's_Game_of_Life#Rules) chosen by Conway.
i.e.:

> 1. Any live cell with two or three live neighbours survives. 
> 2. Any dead cell with three live neighbours becomes a live cell.
> 3. All other live cells die in the next generation. Similarly, all other dead cells stay dead.

This version also has it own set of rules:

> 1. The boundaries are impassable; no cell can exist outside of the game screen.
> 2. Pattern placement only create living cells - the cells around the pattern are not modified.
> 3. The only exception to the 2nd rule is the `Cell` pattern, which can be used both as a brush and an eraser.

Furthermore, the game make use of different colors to represent the state of a cell

| Color                                                        | State | Neighbors |
|:------------------------------------------------------------:|:------|:---------:|
| ![#192424](https://via.placeholder.com/15/192424/192424.png) | Dead  | -         |
| ![#78c030](https://via.placeholder.com/15/78c030/78c030.png) | Alive | 0         |
| ![#a8d848](https://via.placeholder.com/15/a8d848/a8d848.png) | Alive | 1         |
| ![#f0d860](https://via.placeholder.com/15/f0d860/f0d860.png) | Alive | 2         |
| ![#ffc018](https://via.placeholder.com/15/ffc018/ffc018.png) | Alive | 3         |
| ![#f09000](https://via.placeholder.com/15/f09000/f09000.png) | Alive | > 3       |

## Credits

* John Horton Conway for coming up with the Game of Life;
* [Ruby2D](https://github.com/ruby2d/ruby2d) developers for creating this amazing gem.
* [Daniel Shiffman](https://www.youtube.com/channel/UCvjgXvBlbQiydffZU7m1_aw) for the inspiration.
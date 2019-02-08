defmodule Elevator.Constants do
  use Constants
  define state_up,    1 # We want to keep -1/1 to inverse them easily
  define state_down, -1 # Do not change
  define state_idle,  0 # Do not change
  define elevator_1, 'elevator_1' # Can go underground
  define elevator_2, 'elevator_2'
  define elevator_3, 'elevator_3'
end

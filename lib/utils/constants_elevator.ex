defmodule MyConstants do
  use Constants
  define state_up,    1 # We want to keep -1/1 to inverse them easily
  define state_down, -1 # Do not change
  define state_idle,  0 # Do not change
  define eleator1, 'elevator1' # Can go underground
  define eleator2, 'elevator2'
  define eleator3, 'elevator3'
end

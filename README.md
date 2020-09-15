# Elevator

A short modelisation of elevator system in a bank
Developed with Elixir 1.8.1

## Run Test
Run tests with `mix test`

## Get started
run `iex -S mix` to open the console and compils files
To init the system run `{:ok, registry} = Elevator.EventsConsumer.init()`

2 events where implemented :
All events assume that you send them possible data, as the event interface is not proofed.
1/ Modelisation of someone calling an elevator :
`Elevator.EventsConsumer.event({:exterior_call, floor, direction}, registry)` with `floor` an int between -2 and 9 and `direction` is -1 for down, 1 for up
2/ Modelisation of someone choosing a floor inside an elevator :
`Elevator.EventsConsumer.event({:interior_call, elevator_name, direction_floor}, registry)` with `elevator_name` the name of the elevator (`elevator_1`, `elevator_2` or `elevator_3`), and `direction_floor` the floor where the consumer want to go (between -2 and 9)

# elevators

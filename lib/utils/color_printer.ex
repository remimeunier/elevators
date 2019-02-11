defmodule ColorPrinter do

  def print(term, name) do
    case name do
      "elevator_1" -> print_color(term, :green)
      "elevator_2" -> print_color(term, :red)
      "elevator_3" -> print_color(term, :yellow)
      _ -> print_color(term, :white)
    end
  end

  defp print_color(term, color) do
    IO.puts(IO.ANSI.format([color, :bright, term], true))
  end
end

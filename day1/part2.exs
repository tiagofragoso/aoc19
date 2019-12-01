defmodule D1 do
	defp parse_input() do
		File.read!("input.in")
		|> String.split("\n", trim: true)
		|> Enum.map(&String.to_integer/1)
	end

	defp run(input) do
		input
		|> Enum.reduce(0, fn x, acc -> 
			acc + calculate_mass(x)
		end)
	end

	defp calculate_mass(input) do
		fuel = Integer.floor_div(input, 3) - 2
		if fuel <= 0, do: 0, else: fuel + calculate_mass(fuel)
	end

	def main do
		parse_input()
		|> run
		|> IO.puts
	end
end

D1.main()
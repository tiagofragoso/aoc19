defmodule D1 do
	defp parse_input() do
		File.read!("input.in")
		|> String.split("\n", trim: true)
		|> Enum.map(&String.to_integer/1)
	end

	defp part_one(input) do
		input
		|> Enum.sum
	end 

	defp part_two(input) do
		input
		|> Stream.cycle
		|> Enum.reduce_while({0, MapSet.new([0])}, fn move, {current, seen} -> 
			new = move + current
			
			if MapSet.member?(seen, new), 
				do: {:halt, new}, 
				else: {:cont, {new, MapSet.put(seen, new)}}
		end)
	end 

	def main do
		parse_input()
		|> part_two
		|> IO.puts
	end
end

D1.main()
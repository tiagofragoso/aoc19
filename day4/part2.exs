defmodule D4 do
	defp parse_input() do
		File.read!("input.in")
		|> String.trim_trailing
		|> String.split("-", trim: true)
		|> Enum.map(&String.to_integer/1)
	end

	defp run(input) do
		# Naive
		test_password(Enum.at(input, 0), Enum.at(input, 1), Enum.at(input, 0), 0)
	end

	defp test_password(lower_bound, upper_bound, password, count) do
		if password > upper_bound do
			count
		else
			new_count = if valid(password), do: count + 1, else: count
			test_password(lower_bound, upper_bound, password + 1, new_count)
		end
	end

	defp valid(password) do
		charlist = Integer.to_charlist(password)
		isSorted(charlist) && hasDouble(charlist)
	end

	defp isSorted(charlist) do
		Enum.sort(charlist) == charlist
	end

	defp hasDouble(charlist) do
		map = Enum.reduce(charlist, Map.new, fn c, map -> 
			{_, new_map} = Map.get_and_update(map, c, fn value -> 
				new_value = if value == nil, do: 1, else: value + 1
				{value, new_value}
			end)
			new_map
		end)
		Enum.any?(Map.values(map), fn x -> x == 2 end)
	end

	def main do
		parse_input()
		|> run
		|> IO.puts
	end
end

D4.main()
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
		{_, hasDouble} = Enum.reduce_while(charlist, {MapSet.new, false}, fn c, {set, _} -> 
			if MapSet.member?(set, c), do: {:halt, {true, true}}, else: {:cont, {MapSet.put(set, c), false}}
		end)
		hasDouble
	end

	def main do
		parse_input()
		|> run
		|> IO.puts
	end
end

D4.main()
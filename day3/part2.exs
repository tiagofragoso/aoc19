defmodule D3 do
	defp parse_input() do
		File.read!("input.in")
		|> String.split("\n", trim: true)
	end

	defp run(input) do
		{positions, _, _, _} = input
			|> Enum.at(0)
			|> String.split(",", trim: true)
			|> Enum.reduce({Map.new(), 0, 0, 0}, fn move, {acc, x, y, steps} -> 
				store_path(acc, move, x, y, steps)
			end)

		{_, _x, _y, min_steps} = input
			|> Enum.at(1)
			|> String.split(",", trim: true)
			|> Enum.reduce({0, 0, 0, -1}, fn move, {steps, x, y, min_steps} -> 
				{steps, new_x, new_y, s} = check_intersection(positions, move, x, y, steps)
				new_min_steps = 
					if s != -1 do 
						if min_steps != -1 do
							min(min_steps, s)
						else
							s
						end
					else
						min_steps
					end
				{steps, new_x, new_y, new_min_steps}
			end)

		min_steps
	end

	defp check_intersection(positions, move, x, y, steps) do 
		{direction, amount} = parse_move(move)
		check_intersection(positions, direction, amount, x, y, steps, -1)
	end

	defp check_intersection(_positions, _direction, 0, x, y, steps, min_steps) do
		{steps, x, y, min_steps}
	end

	defp check_intersection(positions, direction, amount, x, y, steps, min_steps) do
		new_steps = steps + 1
		{new_x, new_y} = new_position(direction, x, y)
		new_min_steps = 
			if Map.has_key?(positions, {new_x, new_y}) do
				inter_steps = Map.get(positions, {new_x, new_y}) + new_steps

				if min_steps == -1 do
				 	inter_steps
				 else 
				 	min(min_steps, inter_steps)
				 end
			else
				min_steps
			end
		check_intersection(positions, direction, amount-1, new_x, new_y, new_steps, new_min_steps)
	end	

	defp store_path(acc, move, x, y, steps) do
		{direction, amount} = parse_move(move)
		store_path(acc, direction, amount, x, y, steps)
	end
	
	defp store_path(acc, _direction, 0, x, y, steps) do
		{acc, x, y, steps}
	end

	defp store_path(acc, direction, amount, x, y, steps) do
		new_steps = steps + 1
		{new_x, new_y} = new_position(direction, x, y)
		acc = Map.put_new(acc, {new_x, new_y}, new_steps)
		store_path(acc, direction, amount-1, new_x, new_y, new_steps)
	end
	

	defp new_position(direction, x, y) do
		cond do
			direction == "U" -> {x, y-1}
			direction == "D" -> {x, y+1}
			direction == "L" -> {x-1, y}
			direction == "R" -> {x+1, y}
		end
	end

	defp parse_move(move) do
		{String.at(move, 0), String.to_integer(String.slice(move, 1..String.length(move)))}
	end

	def main do
		parse_input()
		|> run
		|> IO.puts
	end
end

D3.main()
defmodule D3 do
	defp parse_input() do
		File.read!("input.in")
		|> String.split("\n", trim: true)
	end

	defp run(input) do
		{positions, _, _} = input
			|> Enum.at(0)
			|> String.split(",", trim: true)
			|> Enum.reduce({MapSet.new(), 0, 0}, fn move, {acc, x, y} -> 
				store_path(acc, move, x, y)
			end)

		{distance, _x, _y} = input
			|> Enum.at(1)
			|> String.split(",", trim: true)
			|> Enum.reduce({-1, 0, 0}, fn move, {distance, x, y} -> 
				{d, new_x, new_y} = check_intersection(positions, move, x, y)
				new_distance = 
					if d != -1 do 
						if distance != -1 do
							min(distance, d)
						else
							d
						end
					else
						distance
					end
				{new_distance, new_x, new_y}
			end)

		distance
	end

	defp check_intersection(positions, move, x, y) do 
		{direction, amount} = parse_move(move)
		check_intersection(positions, direction, amount, x, y, -1)
	end

	defp check_intersection(_positions, _direction, 0, x, y, distance) do
		{distance, x, y}
	end

	defp check_intersection(positions, direction, amount, x, y, distance) do
		{new_x, new_y} = new_position(direction, x, y)
		new_distance = 
			if MapSet.member?(positions, {new_x, new_y}) do
				if distance == -1 do
				 	manhattan_distance(new_x, new_y)
				 else 
				 	min(distance, manhattan_distance(new_x, new_y))
				 end
			else
				distance
			end
		check_intersection(positions, direction, amount-1, new_x, new_y, new_distance)
	end	


	defp manhattan_distance(x, y) do
		abs(x) + abs(y)
	end

	defp store_path(acc, move, x, y) do
		{direction, amount} = parse_move(move)
		store_path(acc, direction, amount, x, y)
	end
	
	defp store_path(acc, _direction, 0, x, y) do
		{acc, x, y}
	end

	defp store_path(acc, direction, amount, x, y) do
		{new_x, new_y} = new_position(direction, x, y)
		acc = MapSet.put(acc, {new_x, new_y})
		store_path(acc, direction, amount-1, new_x, new_y)
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
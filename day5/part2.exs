defmodule D5 do
	defp parse_input() do
		File.read!("input.in")
		|> String.trim_trailing
		|> String.split(",", trim: true)
		|> Enum.map(&String.to_integer/1)
		|> Enum.to_list
	end

	defp run(input) do
		instruction(input, 0)
	end

	defp instruction(input, position) do
		[opcode | param_modes] = 
			Enum.at(input, position)
			|> parse_instruction
		unless opcode == 99 do
			param_count = param_count(opcode)
			params = Enum.slice(input, (position+1)..(position+param_count))
			{new_input, new_position} = operation(opcode, param_modes, params, input)
			new_p = if new_position == nil, do: position + 1 + param_count, else: new_position
			instruction(new_input, new_p)
		end
	end

	defp param_count(1) do 3 end
	defp param_count(2) do 3 end
	defp param_count(3) do 1 end
	defp param_count(4) do 1 end
	defp param_count(5) do 2 end
	defp param_count(6) do 2 end
	defp param_count(7) do 3 end
	defp param_count(8) do 3 end

	defp parse_instruction(instruction) do
		instruction
		|> Integer.to_string
		|> String.pad_leading(5, "0")
		|> String.split("", parts: 4, trim: true)
		|> Enum.reverse
		|> Enum.map(&String.to_integer/1)
	end

	defp operation(1, [m1, m2 | _], [p1, p2, p3 | _], input) do
		value = param_value(input, p1, m1) + param_value(input, p2, m2)
		{List.replace_at(input, p3, value), nil}
	end

	defp operation(2, [m1, m2 | _], [p1, p2, p3 | _], input) do
		value = param_value(input, p1, m1) * param_value(input, p2, m2)
		{List.replace_at(input, p3, value), nil}
	end

	defp operation(3, _, [p1 | _], input) do
		{List.replace_at(input, p1, 5), nil}
	end

	defp operation(4, [m1 | _], [p1 | _], input) do
		IO.puts param_value(input, p1, m1)
		{input, nil}
	end

	defp operation(5, [m1, m2 | _], [p1, p2 | _], input) do
		if param_value(input, p1, m1) != 0 do
			{input, param_value(input, p2, m2)}
		else
			{input, nil}
		end
	end

	defp operation(6, [m1, m2 | _], [p1, p2 | _], input) do
		if param_value(input, p1, m1) == 0 do
			{input, param_value(input, p2, m2)}
		else
			{input, nil}
		end
	end

	defp operation(7, [m1, m2 | _], [p1, p2, p3 | _], input) do
		value = if param_value(input, p1, m1) < param_value(input, p2, m2), do: 1, else: 0
		{List.replace_at(input, p3, value), nil}
	end

	defp operation(8, [m1, m2 | _], [p1, p2, p3 | _], input) do
		value = if param_value(input, p1, m1) == param_value(input, p2, m2), do: 1, else: 0
		{List.replace_at(input, p3, value), nil}
	end

	defp param_value(input, param, mode) do
		if mode == 0 do
			Enum.at(input, param)
		else
			param
		end
	end

	def main do
		parse_input()
		|> run
	end
end

D5.main()
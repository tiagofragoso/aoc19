defmodule D2 do
	defp parse_input() do
		File.read!("input.in")
		|> String.trim_trailing
		|> String.split(",", trim: true)
		|> Enum.map(&String.to_integer/1)
		|> Enum.to_list
	end

	defp restore_input(input) do 
		List.replace_at(input, 1, 12)
		|> List.replace_at(2, 2)
	end

	defp run(input) do
		line_operation(input, 0)
	end

	defp line_operation(input, position) do
		line = Enum.slice(input, position, 4)
		if Enum.at(line, 0) == 99, do: input, else: operation(input, line) |> line_operation(position + 4)
	end

	defp operation(input, line) do
		op = Enum.at(line, 0)
		value = operation(op, input, line)
		List.replace_at(input, Enum.at(line, 3), value)
	end

	defp operation(1, input, line) do
		Enum.at(input, Enum.at(line, 1)) + Enum.at(input, Enum.at(line, 2))
	end

	defp operation(2, input, line) do
		Enum.at(input, Enum.at(line, 1)) * Enum.at(input, Enum.at(line, 2))
	end

	def main do
		parse_input()
		|> restore_input
		|> run
		|> Enum.at(0)
		|> IO.puts
	end
end

D2.main()
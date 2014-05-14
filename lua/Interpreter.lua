Brainfuck = {}

Brainfuck.ErrorCodes = {
	"Closing bracket(s) missing",
	"Opening bracket(s) missing",
	"No source code",
	"Unknown error code",
}

/*
*	Validator
*	
*	Arguments:
*
*	string: Code
*	
*	Returns:
*
*	number: 1 if closing bracket(s) missing.
*	number: 2 if opening bracket(s) missing.
*	number: 0 otherwise.
*
*/

function Brainfuck.Validate(source)
	local i, errorCode, l = 0, 0, 0

	for i = 1, string.len(source), 1 do
		if string.byte(source, i) == 91 then
			l = l + 1
		elseif string.byte(source, i) == 93 then
			l = l - 1
			if l < 0 then return 2 end
		end
	end
	
	if l > 0 then
		return 1
	elseif l < 0 then
		return 2
	else
		return 0
	end
end

/*
*	Error reporter
*	
*	Arguments:
*
*	string: Error
*	
*	Outputs:
*
*	error
*
*/

function Brainfuck.Error(err)
	error(Brainfuck.ErrorCodes[err or 4])
end

/*
*	Tokenizer
*	
*	Arguments:
*
*	string: Code
*	
*	Outputs:
*
*	Msg
*
*/

function Brainfuck.Tokenize(source)
	local memSize, maxVal, mem, pointer, l = 30000, 255, {}, 0, 0

	for i = 0, memSize, 1 do mem[i] = 0 end

	i = 0
	while i <= string.len(source) do
		i = i + 1
		if string.byte(source, i) == 43 then
			if mem[pointer] < maxVal then
				mem[pointer] = mem[pointer] + 1
			end

		elseif string.byte(source, i) == 45 then
			if mem[pointer] > 0 then
				mem[pointer] = mem[pointer] - 1
			end

		elseif string.byte(source, i) == 44 then
			mem[pointer] = string.byte(source:read('*l'), 1)

		elseif string.byte(source, i) == 46 then
			Msg(string.char(mem[pointer]))

		elseif string.byte(source, i) == 60 then
			pointer = pointer - 1
			if pointer < 0 then pointer = 0 end

		elseif string.byte(source, i) == 62 then
			pointer = pointer + 1
			if pointer > memSize then pointer = memSize end

		elseif string.byte(source, i) == 91 then
			if mem[pointer] == 0 then
				while (string.byte(source, i) ~= 93) or (l > 0) do
					i = i + 1
					if string.byte(source, i) == 91 then l = l + 1 end
					if string.byte(source, i) == 93 then l = l - 1 end
				end
			end
		elseif string.byte(source, i) == 93 then
			if mem[pointer] ~= 0 then
				while (string.byte(source, i) ~= 91) or (l > 0) do
					i = i - 1
					if string.byte(source, i) == 91 then l = l - 1 end
					if string.byte(source, i) == 93 then l = l + 1 end
				end
			end
		end
	end
end

/*
*	Interpreter (In Lua Translator)
*	
*	Arguments:
*
*	string: Code
*
*	Outputs:
*
*	Msg or Error
*
*/

function Brainfuck.Compile(source)
	errorCode = Brainfuck.Validate(source)
	if errorCode == 0 then
		Brainfuck.Tokenize(source)
	else
		Brainfuck.Error(errorCode)
	end
end
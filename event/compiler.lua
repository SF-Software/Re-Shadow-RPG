local Lust = require "lib.template"
local pprint = require "lib.pprint"

local NodeType = {
    Token = 1,
    Symbol = 2,
    String = 3,
    Boolean = 4,
    Number = 5,
    Operator = 6,
    Sequence = 7
}

local processor = {}
local function process_node(v)
    print("---------", v[1])
    pprint(v)
    return processor[v[1]](select(2, unpack(v)))
end

local template = {}
template.if_then = Lust [[
(function()
if $exp then
	return $thenc
end
end)()]]
template.if_then_else = Lust [[
(function()
if $exp then
	return $thenc
else
	return $elsec
end
end)()]]

do
    local operator = {}
    do
        operator["+"] = function(a, b)
            return "(" .. process_node(a) .. " + " .. process_node(b) .. ")"
        end
        operator["-"] = function(a, b)
            return "(" .. process_node(a) .. " - " .. process_node(b) .. ")"
        end
        operator["*"] = function(a, b)
            return "(" .. process_node(a) .. " * " .. process_node(b) .. ")"
        end
        operator["/"] = function(a, b)
            return "(" .. process_node(a) .. " / " .. process_node(b) .. ")"
        end
    end
    local special_forms = {}
    do
        special_forms["if"] =
            function(...)
            if select("#", ...) == 2 then
                local exp, then_seq = ...
                return if_then:gen {
                    exp = process_node(exp),
                    thenc = process_node(thenseq)
                }
            elseif select("#", ...) == 3 then
                local exp, then_seq, else_seq = ...
                return template.if_then_else:gen {
                    exp = process_node(exp),
                    thenc = process_node(then_seq),
                    elsec = process_node(else_seq)
                }
            end
        end
    end

    processor[NodeType.Number] = function(num)
        return tostring(num)
    end
    processor[NodeType.Boolean] = function(bool)
        return tostring(bool)
    end
    processor[NodeType.String] = function(str)
        return str
    end

    processor[NodeType.Operator] = function(op, ...)
        return operator[op](...)
    end

    processor[NodeType.Token] = function(tok, ...)
        if special_forms[tok] then
            return special_forms[tok](...)
        else
            return tok
        end
    end

    processor[NodeType.Sequence] = function(...)
        local seq = {...}
        local buffer = {"(function()"}
        for k, v in ipairs(seq) do
            table.insert(buffer, process_node(v))
        end
        table.insert(buffer, "end)()")
        return table.concat(buffer, "\n")
    end
end

local function compile(ast)
    return process_node(ast)
end

print(
    compile(
        {
            NodeType.Sequence,
            {NodeType.Token, "if", {NodeType.Boolean, true}, {NodeType.Boolean, false}, {NodeType.Boolean, true}}
        }
    )
)
return compile

--[[
CmdMsg ::= String
Block ::= "{" {Command} "}"
Value ::= "\"" String "\"" | Integer | String | Block
Keyvalue ::= String ":" Value
CmdArgs ::= {Value | Keyvalue}
CmdDefault ::= CmdName [CmdArgs]
CmdBody ::= CmdMsg | CmdDefualt
Command::= "(" CmdBody ")"

]]
 

function print_r ( t ) 
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    sub_print_r(t,"  ")
end



function works()
	local fp,file
	local pos=1

	local function nextchar()
		pos=pos+1;
	end
	local function lastchar()
		pos=pos-1;
	end
	local function nowchar(c)
		c=c or 0
		return file:sub(pos+c,pos+c)
	end

	local function isblank(c)
		c=c or 0
		return nowchar(c)==' ' or nowchar(c)=='\t' or nowchar(c)=='\n' or nowchar(c)=='\r'
	end
	local function isstart(c)
		c=c or 0
		return nowchar(c)=='('
	end

	local function readstring()
		local function reades()
			local ret
			if nowchar()=='\\' then 
				ret= "\\"
			elseif nowchar()=='n' then
				ret="\n"
			elseif nowchar()=='"' then
				ret='"'
			else
				error('Unknow Escape Sequence: "\\'..nowchar()..'"')
			end
			nextchar()
			return ret
		end
		local str="";
		nextchar()
		while true do
			if nowchar()=="\\" then
				nextchar()
				str=str..reades()
			elseif nowchar()=='"' then
				nextchar()
				break
			else
				str=str..nowchar()
				nextchar()
			end

		end
		
		return str;
	end
	local function readcomment()
		local cmt=""
		nextchar()
		while nowchar()~='\n' do cmt=cmt..nowchar() nextchar() end
		return cmt
	end
	local function readnumber()
		local float = 0
		local n=0
		while true do
			if nowchar()=='.' then
				if float>0 then
					error("Wrong Number Input")
				else
					float=1
				end
			elseif string.byte(nowchar())>=string.byte(0) and string.byte(nowchar())<=string.byte(9) then
				if float>0 then
					n=n+(string.byte(nowchar())-string.byte(0))*(10^-float)
					float=float+1
				else
					n=n*10+(string.byte(nowchar())-string.byte(0))
				end
			else
				break
			end
			nextchar()
		end
		return n
	end
	local function readsymbol()
		local sym=""
		while true do
			if isblank() or nowchar()==':' or nowchar()=='(' or nowchar()==')' or nowchar()=='{' or nowchar()=='}' 
				or (nowchar()=='=' and nowchar(1)=='>') then
				break
			else
				sym=sym..nowchar()
				nextchar()
			end
		end
		return sym
	end

	function readtokens()
		local token={}
		while nowchar()~="" do
			if nowchar()=='"' then
				local tmp=readstring()--:gsub("\n","\\n")
				
				table.insert(token,{"String",tmp})
				goto over
			end
			if nowchar()=='#' then
				table.insert(token,{"Comment",readcomment()})
				goto over
			end
			if nowchar()=='{' then
				
				table.insert(token,{"BeginBlock"})
				table.insert(token,{"Newline"})
				nextchar()
				goto over
			end
			if nowchar()=='-' then
				if isblank(-1) or isstart(-1) then
					nextchar()
					if (string.byte(nowchar())>=string.byte(0) and string.byte(nowchar())<=string.byte(9)) then
						table.insert(token,{"Number",-readnumber()})
						goto over
					else
						lastchar()
					end
				end
			end
			if (string.byte(nowchar())>=string.byte(0) and string.byte(nowchar())<=string.byte(9)) then
				table.insert(token,{"Number",readnumber()})
				goto over
			end
			if nowchar()=='}' then
				table.insert(token,{"Newline"})
				table.insert(token,{"EndBlock"})
				nextchar()
				goto over
			end
			if nowchar()=='(' then
				table.insert(token,{"BeginCommand"})
				nextchar()
				goto over
			end
			if nowchar()==')' then
				table.insert(token,{"EndCommand"})
				nextchar()
				goto over
			end
			if nowchar()=='=' and nowchar(1)=='>' then
				table.insert(token,{"Keyvalue"})
				nextchar()nextchar()
				goto over
			end
			if nowchar()==':' then
				table.insert(token,{"SymbolConst"})
				nextchar()
				goto over
			end
			if nowchar()=='\n' then
				table.insert(token,{"Newline"})
				nextchar()
				goto over
			end
			if nowchar()==' ' or nowchar()=='\t' or nowchar()=='\n' or nowchar()=='\r' then
				nextchar()
				goto over
			end
			table.insert(token,{"Symbol",readsymbol()})
			::over::
		end
		table.insert(token,{"Eof"})
	--	print_r(token)
		--print_r(process_tokens(token))
		return token
	end

	function process_tokens(tokens)
		local index=1
		local function _next()
			index= index+1
		end
		local function next_token()
			return tokens[index+1]
		end
		local function last_token()
			return tokens[index-1]
		end
		local function current_token()
			return tokens[index]
		end
		local readcommand
		local function readblock(endmark)
			local outs={}
			
			while current_token()[1]~="Eof" do
				if current_token()[1]==endmark then
					_next()
					return outs
				end
				if current_token()[1]=="Newline" or current_token()[1]=="Comment" then
					_next()
				elseif current_token()[1]=="BeginCommand" then
					_next()
					table.insert(outs,{"#c",readcommand("EndCommand")})
				elseif current_token()[1]=="Symbol" then
					table.insert(outs,{"#c",readcommand("Newline")})
				elseif current_token()[1]=="String" then
					table.insert(outs,{"#c",{{"#v","msg"},unpack(readcommand("Newline"))}})
				end
			end
			if endmark~="Eof" then
				error("expected '}' but got EOF")
			end
			return outs
		end
		readcommand=function(endmark)
			local function readvalue()
				local ret
				if current_token()[1]=="Symbol" then
					ret = {"#v",current_token()[2]}
					_next()
				elseif current_token()[1]=="SymbolConst" then
					if next_token()[1]=="Symbol" then
						_next()	
						ret = {"#s",current_token()[2]}
						_next()
					else
						error("Not a Symbol!")
					end
				elseif current_token()[1]=="String" then
					ret = {"#s",current_token()[2]}
					_next()
				elseif current_token()[1]=="Number" then
					ret = {"#n",current_token()[2]}
					_next()
				elseif current_token()[1]=="BeginCommand" then
					_next()
					ret =  {"#c",readcommand("EndCommand")}
				elseif current_token()[1]=="BeginBlock" then
					_next()
					ret = {"#b",readblock("EndBlock")}
				else
					_next()
				end
				return ret
			end
			local command = {}
			
			while current_token()[1]~="Eof" do
				if current_token()[1]==endmark then
					_next()
					return command
				end
				if current_token()[1]=="Symbol" and next_token()[1]=="Keyvalue"then
					local key = current_token()[2]
					_next()
					_next()
					table.insert(command,{"#k",key,readvalue()})
				else
					table.insert(command,readvalue())
				end
			end
			
			error("expected ')' but got EOF")
		end
		return {"#b",readblock("Eof")}
	end


	fp = io.open(arg[1],"r")
	file = fp:read("*a")
	file="\n"..file.."\n"
	file=file:gsub("^%s+",'')
	file=file:gsub("\n%s+",'\n')
	file=file:gsub("%s+\n",'\n')
	local le=string.char(27)
	local lr=string.char(14)
	fp:close()
	cjson = require "cjson"
	local index=0
	if file:sub(1,3)==string.char(0xef)..string.char(0xbb)..string.char(0xbf) then	
		io.stderr:write([[
			Sorry,but you put a utf8 file with BOM,please use a file without BOM!
		]])
		return
	end



	local oktb=process_tokens(readtokens())

	print(cjson.encode(oktb))
end


works()



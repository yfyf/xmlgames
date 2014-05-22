local lxp = require "lxp"

local state = 0

function start_element(parser, name)
    if name == "ProductUrl" then
        state = 1
    end
end

function char_data(parser, data)
    if state == 1 then
        print (data)
        state = 0
    end
end

local p = lxp.new({StartElement = start_element, CharacterData = char_data})
local f = io.open(arg[1], 'r')

local done = false
while not done do
    local l = f:read(65536)
    done = l:len() ~= 65536
    p:parse(l)
end
p:parse()
p:close()
f:close()

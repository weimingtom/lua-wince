
require "alien"

local coredll = alien.load("coredll.dll")

coredll.malloc:types("pointer", "int")
coredll.free:types("void", "pointer")
coredll.MultiByteToWideChar:types("int", "int", "int", "string", "int", "pointer", "int")
coredll.MessageBoxW:types("int", "int", "pointer", "pointer", "int")

function make_wide(str)
    local codePage = 65001	-- CP_UTF8
    local flags = 0
    local wide_len = coredll.MultiByteToWideChar(codePage, flags, str, #str+1, nil, 0)
    local buffer = coredll.malloc(2 * wide_len)
    local res = coredll.MultiByteToWideChar(codePage, flags, str, #str+1, buffer, wide_len)
    return buffer
end

local foo = make_wide("Hello, world!")

coredll.MessageBoxW(0, foo, nil, 0)

coredll.free(foo)

LUA_EXE = ...
CEU_VER = 'v0.40'
CEU_GIT = ''
    do
        local f = assert(io.popen('git rev-parse HEAD'))
        CEU_GIT = string.sub(f:read'*a',1,-2)
        assert(f:close())
    end

if not LUA_EXE then
    io.stderr:write('Usage: <lua> pak.lua <lua>\n')
    os.exit(1)
end

local fout = assert(io.open('ceu','w'))
local fin  = assert(io.open'ceu.lua'):read'*a'

local function subst_lua (name, returns)
    local s, e = string.find(fin, "dofile '"..name.."'")
    local src do
        if returns then
            src = '\n(function()\n' ..
                    assert(io.open(name)):read'*a' ..
                  '\nend)()\n'
        else
            src = '\ndo\n' ..
                    assert(io.open(name)):read'*a' ..
                  '\nend\n'
        end
    end
    fin = string.sub(fin, 1, (s-1)) .. src .. string.sub(fin, (e+1))
end

local function subst_c (str, from, to)
    assert(to, from)
    local i,e = string.find(str, from, 1, true)
    if i then
        return subst_c(string.sub(str,1,i-1) .. to .. string.sub(str,e+1),
                       from, to)
    else
        return str
    end
end

subst_lua('optparse.lua', true)
subst_lua 'dbg.lua'
subst_lua 'cmd.lua'
subst_lua 'pre.lua'
subst_lua 'lines.lua'
subst_lua 'parser.lua'
subst_lua 'ast.lua'
subst_lua 'adjs.lua'
subst_lua 'types.lua'
subst_lua 'exps.lua'
subst_lua 'dcls.lua'
subst_lua 'inlines.lua'
subst_lua 'consts.lua'
subst_lua 'fins.lua'
subst_lua 'spawns.lua'
subst_lua 'stmts.lua'
subst_lua 'inits.lua'
subst_lua 'ptrs.lua'
subst_lua 'scopes.lua'
subst_lua 'tight_.lua'
subst_lua 'props_.lua'
subst_lua 'trails.lua'
subst_lua 'labels.lua'
subst_lua 'vals.lua'
subst_lua 'multis.lua'
subst_lua 'mems.lua'
subst_lua 'codes.lua'
subst_lua 'env.lua'
subst_lua 'cc.lua'

local ceu_vector_h   = assert(io.open'../c/ceu_vector.h'):read'*a'
local ceu_vector_c   = assert(io.open'../c/ceu_vector.c'):read'*a'
local ceu_pool_c     = assert(io.open'../c/ceu_pool.c'):read'*a'
local ceu_c          = assert(io.open'../c/ceu.c'):read'*a'
ceu_c = subst_c(ceu_c, '=== CEU_VECTOR_H ===',   ceu_vector_h)
ceu_c = subst_c(ceu_c, '=== CEU_VECTOR_C ===',   ceu_vector_c)
ceu_c = subst_c(ceu_c, '=== CEU_POOL_C ===',     ceu_pool_c)

fout:write([=[
#!/usr/bin/env ]=]..LUA_EXE..[=[

--[[
-- This file is automatically generated.
-- Check the github repository for a readable version:
-- http://github.com/ceu-lang/ceu
--
-- Céu is distributed under the MIT License:
--

Copyright (C) 2012-2016 Francisco Sant'Anna

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--
--]]

PAK = {
    lua_exe = ']=]..LUA_EXE..[=[',
    ceu_ver = ']=]..CEU_VER..[=[',
    ceu_git = ']=]..CEU_GIT..[=[',
    files = {
        ceu_c = [====[]=]..'\n'..ceu_c..[=[]====],
    }
}
]=]..fin)

fout:close()
os.execute('chmod +x ceu')

local c = ''

--env-header
do
    local f = ASR(io.open(CEU.opts.env_header))
    c = c..'\n\n/* ENV_HEADER */\n\n'..f:read'*a'
    f:close()
end

--env-ceu
do
    local f = ASR(io.open(CEU.opts.env_ceu))
    c = c..'\n\n/* ENV_CEU */\n\n'..f:read'*a'
    f:close()
end

--env-main
do
    local f = ASR(io.open(CEU.opts.env_main))
    c = c..'\n\n/* ENV_MAIN */\n\n'..f:read'*a'
    f:close()
end

--env-output
do
    local out = [[
/*
* This file is automatically generated.
* http://www.ceu-lang.org/
* http://github.com/fsantanna/ceu/
*
* Céu is distributed under the MIT License:
*

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
*/

]] .. c

    if CEU.opts.env_output == '-' then
        print(out)
    else
        local f = ASR(io.open(CEU.opts.env_output,'w'))
        f:write(out)
        f:close()
    end
end

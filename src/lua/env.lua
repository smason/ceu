local c = ''

--env-types
do
    local f = ASR(io.open(CEU.opts.env_types))
    c = c..'\n\n/* ENV_HEADER */\n\n'..f:read'*a'
    f:close()
end

--env-threads
do
    if CEU.opts.env_threads then
        local f = ASR(io.open(CEU.opts.env_threads))
        c = c..'\n\n/* ENV_THREADS */\n\n'..f:read'*a'
        f:close()
    end
end

-- callbacks
do
    c = c..[[
typedef union tceu_callback_arg {
    void* ptr;
    s32   num;
    usize size;
} tceu_callback_arg;

typedef struct tceu_callback_ret {
    bool is_handled;
    tceu_callback_arg value;
} tceu_callback_ret;

tceu_callback_ret ceu_callback (int cmd, tceu_callback_arg p1, tceu_callback_arg p2);

#define ceu_callback_void_void(cmd)                     \
        ceu_callback(cmd, (tceu_callback_arg){},        \
                          (tceu_callback_arg){})
#define ceu_callback_num_void(cmd,p1)                   \
        ceu_callback(cmd, (tceu_callback_arg){.num=p1}, \
                          (tceu_callback_arg){})
#define ceu_callback_num_ptr(cmd,p1,p2)                 \
        ceu_callback(cmd, (tceu_callback_arg){.num=p1}, \
                          (tceu_callback_arg){.ptr=p2})
#define ceu_callback_num_num(cmd,p1,p2)                 \
        ceu_callback(cmd, (tceu_callback_arg){.num=p1}, \
                          (tceu_callback_arg){.num=p2})
#define ceu_callback_ptr_num(cmd,p1,p2)                 \
        ceu_callback(cmd, (tceu_callback_arg){.ptr=p1}, \
                          (tceu_callback_arg){.num=p2})
#define ceu_callback_ptr_size(cmd,p1,p2)                \
        ceu_callback(cmd, (tceu_callback_arg){.ptr=p1}, \
                          (tceu_callback_arg){.size=p2})

#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#define ceu_callback_assert_msg_ex(v,msg,file,line)                              \
    if (!(v)) {                                                                  \
        if ((msg)!=NULL) {                                                       \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)"[");               \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)(file));            \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)":");               \
            ceu_callback_num_num(CEU_CALLBACK_LOG, 2, line);                     \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)"] ");              \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)"runtime error: "); \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)(msg));             \
            ceu_callback_num_ptr(CEU_CALLBACK_LOG, 0, (void*)"\n");              \
        }                                                                        \
        ceu_callback_num_ptr(CEU_CALLBACK_ABORT, 0, NULL);                       \
    }
#define ceu_callback_assert_msg(v,msg) ceu_callback_assert_msg_ex((v),(msg),__FILE__,__LINE__)

#define ceu_dbg_assert(v) ceu_callback_assert_msg(v,"bug found")

enum {
    CEU_CALLBACK_START,
    CEU_CALLBACK_STOP,
    CEU_CALLBACK_STEP,
    CEU_CALLBACK_ABORT,
    CEU_CALLBACK_LOG,
    CEU_CALLBACK_TERMINATING,
    CEU_CALLBACK_ASYNC_PENDING,
    CEU_CALLBACK_THREAD_TERMINATING,
    CEU_CALLBACK_WCLOCK_MIN,
    CEU_CALLBACK_OUTPUT,
    CEU_CALLBACK_REALLOC,
};
]]
end

if TESTS then
    c = c .. [[
u32 _ceu_tests_trails_visited_ = 0;
]]
end

--env-ceu
do
    local f = ASR(io.open(CEU.opts.env_ceu))
    c = c..'\n\n/* ENV_CEU */\n\n'..f:read'*a'
    f:close()
end

--env-main
do
    if CEU.opts.env_main then
        local f = ASR(io.open(CEU.opts.env_main))
        c = c..'\n\n/* ENV_MAIN */\n\n'..f:read'*a'
        f:close()
    end
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

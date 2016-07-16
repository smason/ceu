local P, C, V, S, Cc, Ct = m.P, m.C, m.V, m.S, m.Cc, m.Ct

--local __debug = true
local spc = 0
if __debug then
    local VV = V
    V = function (id)
        return
            m.Cmt(P'',
                function ()
                    DBG(string.rep(' ',spc)..'>>>', id)
                    spc = spc + 2
                    return true
                end)
            * (
                VV(id) * m.Cmt(P'',
                            function ()
                                spc = spc - 2
                                DBG(string.rep(' ',spc)..'+++', id)
                                return true
                            end)
              + m.Cmt(P'',
                    function ()
                        spc = spc - 2
                        DBG(string.rep(' ',spc)..'---', id)
                        return false
                    end) * P(false)
            )
    end
end

local x = V'__SPACE'^0
local X = V'__SPACE'^1

local T = {
    {
        '`%*´ or `/´ or `%%´ or `%+´ or `%-´ or `>>´ or `<<´ or `&´ or `^´ or `|´ or `!=´ or `==´ or `<=´ or `>=´ or `<´ or `>´ or `and´ or `or´',
        'binary operator'
    },
    {
        '`%*´ or `/´ or `%%´ or `%+´ or `%-´ or `>>´ or `<<´ or `^´ or `|´ or `!=´ or `==´ or `<=´ or `>=´ or `<´ or `>´ or `and´ or `or´',
        'binary operator'
    },

    {
        '`&&´ or `%?´',
        'type modifier'
    },

    {
        '`&´ or `%(´ or primitive type or abstraction identifier or native identifier',
        'type'
    },
    {
        'primitive type or abstraction identifier or native identifier',
        'type'
    },

    {
        '`native´ or `code/instantaneous´ or `code/delayed´ or end of file',
        'end of file'
    },
    {
        '`;´ or `native´ or `code/instantaneous´ or `code/delayed´ or `with´',
        '`with´'
    },
    {
        '`native´ or `code/instantaneous´ or `code/delayed´ or `end´',
        '`end´'
    },

    {
        '`%(´ or internal identifier or native identifier or `global´ or `this´ or `outer´ or `{´',
        'name expression'
    },
    {
        '`%*´ or `%$´ or name expression',
        'name expression'
    },
    {
        '`%*´ or `%$´ or internal identifier or native identifier or `global´ or `this´ or `outer´',
        'name expression'
    },
    {
        'abstraction identifier or name expression',
        'name expression'
    },

    {
        '`do´ or `await´ or `async/thread´ or `%[´ or `call/recursive´ or `call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´ or `emit´ or `val´ or `new´ or `spawn´ or `_´ or `request´ or `watching´',
        'expression'
    },
    {
        '`call/recursive´ or `call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´',
        'expression'
    },
    {
        '`do´ or `await´ or `async/thread´ or `%[´ or `emit´ or `call/recursive´ or `call´ or `val´ or `new´ or `spawn´ or `_´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´ or `request´ or `watching´',
        'expression'
    },
    {
        'name expression or `call/recursive´ or `call´ or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal or `not´ or `%-´ or `%+´ or `~´ or `%$%$´',
        'expression'
    },
    {
        '`not´ or `%-´ or `%+´ or `~´ or `%$%$´ or `call/recursive´ or `call´ or name expression or `&&´ or `&´ or `sizeof´ or `null´ or number or `false´ or `true´ or `"´ or string literal',
        'expression'
    },

    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code/instantaneous´ or `code/delayed´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `async´ or `async/thread´ or `async/isr´ or `atomic´ or `pre´ or `%[´ or `escape´ or `break´ or `continue´ or `par´ or end of file',
        'statement'
    },
    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code/instantaneous´ or `code/delayed´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `async´ or `async/thread´ or `async/isr´ or `atomic´ or `pre´ or `%[´ or `escape´ or `break´ or `continue´ or `par´ or `end´',
        'statement'
    },
    {
        '`nothing´ or `var´ or `vector´ or `pool´ or `event´ or `input´ or `output´ or `data´ or `code/instantaneous´ or `code/delayed´ or `input/output´ or `output/input´ or `native´ or `deterministic´ or `%*´ or name expression or `await´ or `emit´ or `call/recursive´ or `call´ or `request´ or `spawn´ or `kill´ or `do´ or `if´ or `loop´ or `every´ or `par/or´ or `par/and´ or `watching´ or `pause/if´ or `async´ or `async/thread´ or `async/isr´ or `atomic´ or `pre´ or `%[´ or `escape´ or `break´ or `continue´ or `par´ or end of file',
        'statement'
    },
}
if RUNTESTS then
    RUNTESTS.parser_translate = RUNTESTS.parser_translate or { ok={}, original=T }
end

-- ( ) . % + - * ? [ ] ^ $

local function translate (msg)
    for i,t in ipairs(T) do
        local fr,to = unpack(t)
        local new = string.gsub(msg, fr, to)
        if RUNTESTS then
            if msg ~= new then
                RUNTESTS.parser_translate.ok[i] = true
            end
        end
        msg = new
--return new
    end
    return msg
end

local ERR_i    = 0
local ERR_strs = {}
local LST_i    = 0
local LST_str  = 'begin of file'

local IGN = 0
local ign_inc   = m.Cmt(P'', function() IGN=IGN+1 return true  end)
local ign_dec_t = m.Cmt(P'', function() IGN=IGN-1 return true  end)
local ign_dec_f = m.Cmt(P'', function() IGN=IGN-1 return false end)

local function I (patt)
    return ign_inc * (patt*ign_dec_t + ign_dec_f*P(false))
end

local function ERR ()
--DBG(LST_i, ERR_i, ERR_strs, _I2L[LST_i], I2TK[LST_i])
    local file, line = unpack(CEU.i2l[LST_i])
    return 'ERR : '..file..
              ' : line '..line..
              ' : after `'..LST_str..'´'..
              ' : expected '..translate(table.concat(ERR_strs,' or '))
end

local function fail (i, err)
    if i==ERR_i and (not ERR_strs[err]) then
        ERR_strs[#ERR_strs+1] = err
        ERR_strs[err] = true
    elseif i > ERR_i then
        ERR_i = i
        ERR_strs = { err }
        ERR_strs[err] = true
    end
    return false
end

-- KK accepts leading chars
local function KK (patt, err, nox)
    if type(patt) == 'string' then
        err = err or '`'..patt..'´'
    else
        err = err or error(debug.traceback())
    end

    local ret = m.Cmt(patt,
                    -- SUCCESS
                    function (_, i, tk)
                        if IGN>0 then return true end
if __debug then
    DBG(string.rep(' ',spc)..'|||', '|'..tk..'|')
end
                        if i > LST_i then
                            LST_i   = i
                            LST_str = tk
                        end
                        return true
                    end)
              + m.Cmt(P'',
                    -- FAILURE
                    function (_,i)
                        if err==true or IGN>0 then return false end
                        return fail(i,err)
                    end) * P(false)
                           -- (avoids "left recursive" error (explicit fail))

    if not nox then
        ret = ret * x
    end
    return ret
end

-- K is exact match
local function K (patt, err, nox)
    err = err or '`'..patt..'´'
    patt = patt * -m.R('09','__','az','AZ','\127\255')
    return KK(patt, err, nox)
end

local CKK = function (tk,err,nox)
    local patt = C(KK(tk,err,true))
    if nox == nil then
        patt = patt * x
    end
    return patt
end
local CK = function (tk,err,nox)
    local patt = C(K(tk,err,true))
    if nox == nil then
        patt = patt * x
    end
    return patt
end

local OPT = function (patt)
    return patt + Cc(false)
end

local PARENS = function (patt)
    return KK'(' * patt * KK')'
end

local E = function (msg)
    return m.Cmt(P'',
            function (_,i)
                return fail(i,msg)
            end)
end

-- TODO; remove
local EE = function (msg)
    return m.Cmt(P'',
            function (_,i)
                RUNTESTS_TODO = true
                return fail(i,msg)
            end)
end

-->>> OK
local TYPES = P'bool' + 'byte'
            + 'f32' + 'f64' + 'float'
            + 'int'
            + 's16' + 's32' + 's64' + 's8'
            + 'ssize'
            + 'u16' + 'u32' + 'u64' + 'u8'
            + 'uint' + 'usize' + 'void'
--<<<

-- must be in reverse order (to count superstrings as keywords)
KEYS = P
'with' +
'watching' +
'vector' +
'var' +
'val' +
'until' +
'true' +
'this' +
'then' +
'spawn' +
'sizeof' +
'request' +
'pre' +
'pool' +
'pause/if' +
'par/or' +
'par/and' +
'par' +
'output/input' +
'output' +
'outer' +
'or' +
'null' +
'nothing' +
'not' +
'new' +
'native' +
'loop' +
'kill' +
'is' +
-- TODO: remove class/interface
'class' + 'interface' + 'traverse' +
'input/output' +
'input' +
'in' +
'if' +
'global' +
'FOREVER' +
'finalize' +
'false' +
'every' +
'event' +
'escape' +
'end' +
'emit' +
'else/if' +
'else' +
'do' +
'deterministic' +
'data' +
'continue' +
'code' +
'call/recursive' +
'call' +
'break' +
'await' +
'atomic' +
'async/thread' +
'async/isr' +
'async' +
'as' +
'and' +
TYPES

KEYS = KEYS * -m.R('09','__','az','AZ','\127\255')

local Alpha    = m.R'az' + '_' + m.R'AZ'
local Alphanum = Alpha + m.R'09'
local ALPHANUM = m.R'AZ' + '_' + m.R'09'
local alphanum = m.R'az' + '_' + m.R'09'

-- Rule:    unchanged in the AST
-- _Rule:   changed in the AST as "Rule"
-- __Rule:  container for other rules, not in the AST
-- __rule:  (local) container for other rules

GG = { [1] = x * V'_Stmts' * V'EOF' * (P(-1) + E('end of file'))

-->>> OK

    , __seqs = KK';' * KK(';',true)^0     -- "true": ignore as "expected"
    , Nothing = K'nothing'
    , EOF = P''
    , EOC = P''

-- DO, BLOCK

    -- escape/A 10
    -- break/i
    -- continue/i
    , _Escape   = K'escape'   * ('/'*V'ID_int' + Cc(true)) * OPT(V'__Exp')
    , Break    = K'break'    * OPT('/'*V'ID_int')
    , Continue = K'continue' * OPT('/'*V'ID_int')

    -- do/A ... end
    , Do = K'do' * ('/'*(V'ID_int'+V'ID_any') + Cc(true)) *
                V'Block' *
           K'end'

    , __Do  = K'do' * V'Block' * K'end'
    , _Dopre = K'pre' * V'__Do'

    , Block = V'_Stmts'

-- PAR, PAR/AND, PAR/OR

    , Par     = K'par' * K'do' *
                 V'Block' * (K'with' * V'Block')^1 *
                K'end'
    , Par_And = K'par/and' * K'do' *
                V'Block' * (K'with' * V'Block')^1 *
               K'end'
    , Par_Or  = K'par/or' * K'do' *
                V'Block' * (K'with' * V'Block')^1 *
               K'end'

-- FLOW CONTROL

    , _If = K'if' * V'__Exp' * K'then' * V'Block' *
            (K'else/if' * V'__Exp' * K'then' * V'Block')^0 *
            OPT(K'else' * V'Block') *
            K'end'

    , Loop       = K'loop' * OPT('/'*V'__Exp') *
                   V'__Do'
    , _Loop_Num  = K'loop' * OPT('/'*V'__Exp') *
                    (V'__ID_int'+V'ID_any') * OPT(
                        K'in' * (CKK'[' + CKK']') * (
                                    V'__Exp' * CKK'->' * (V'ID_any' + V'__Exp') +
                                    (V'ID_any' + V'__Exp') * CKK'<-' * V'__Exp'
                                ) * (CKK'[' + CKK']') *
                                OPT(KK',' * V'__Exp')
                    ) *
                   V'__Do'
    , _Loop_Pool = K'loop' * OPT('/'*V'__Exp') *
                    (V'ID_int'+V'ID_any') * K'in' * V'Exp_Name' *
                   V'__Do'

    , _Every  = K'every' * OPT((V'ID_int'+PARENS(V'Varlist')) * K'in') *
                    (V'_Await_Until'+V'Await_Wclock') *
                V'__Do'

    , Stmt_Call = V'Abs_Call' + V'Exp_Call'

    , Mark = C''
    , __fin_stmt   = V'___fin_stmt' * V'__seqs'
    , ___fin_stmt  = V'Nothing'
                   + V'_Set'
                   + V'Emit_Ext_emit' + V'Emit_Ext_call'
                   + V'Stmt_Call'
    , __finalize   = K'finalize' * (PARENS(V'Namelist') + V'Mark') * K'with' *
                     V'Block' *
                   K'end'
    , Finalize     = K'do' * OPT(V'__fin_stmt') * V'__finalize'

    , _Var_set_fin = K'var' * KK'&' * V'Type' * V'__ID_int'
                   * (KK'='-'==') * KK'&' * V'Exp_Call' * V'__finalize'

    , __Stmt_Block = V'_Code_impl' + V'_Ext_Code_impl' + V'_Ext_Req_impl'
              + V'_Data_block'
              + V'Nat_Block'
              + V'Do'    + V'_If'
              + V'Loop' + V'_Loop_Num' + V'_Loop_Pool'
              + V'_Every'
              + V'_Spawn_Block'
              + V'Finalize'
              + V'Par_Or' + V'Par_And' + V'_Watching'
              + V'Pause_If'
              + V'Async' + V'_Async_Thread' + V'_Async_Isr' + V'Atomic'
              + V'_Dopre'
              + V'_Lua'


    , Pause_If = K'pause/if' * (V'Exp_Name'+V'ID_ext') * V'__Do'

-- ASYNCHRONOUS

    , Async   = K'async' * (-P'/thread'-'/isr') * OPT(PARENS(V'Varlist')) *
                V'__Do'
    , _Async_Thread = K'async/thread' * OPT(PARENS(V'Varlist')) * V'__Do'
    , _Async_Isr    = K'async/isr'    *
                        KK'[' * V'Explist' * KK']' *
                            OPT(PARENS(V'Varlist')) *
                      V'__Do'
    , Atomic  = K'atomic' * V'__Do'

-- CODE / EXTS (call, req)

    -- CODE

    , __code = (CK'code/instantaneous' + CK'code/delayed')
                * OPT(CK'/recursive')
                * (V'__ID_abs'-V'__id_data')
    , _Code_proto = V'__code' * (V'Typepars_ids'+V'Typepars_anon') *
                                    KK'=>' * V'Type'
    , _Code_impl  = V'__code' * V'Typepars_ids' *
                                    KK'=>' * V'Type' *
                    V'__Do' * V'EOC'

    , _Spawn_Block = K'spawn' * V'__Do'

    -- EXTS

    -- call
    , __extcode = (CK'input/output' + CK'output/input') * K'/instantaneous'
                    * OPT(CK'/recursive')
                    * V'__ID_ext'
* EE'TODO-PARSER: extcode'
    , _Ext_Code_proto  = V'__extcode' * (V'Typepars_ids'+V'Typepars_anon') *
                                        KK'=>' * V'Type'
    , _Ext_Code_impl  = V'__extcode' * V'Typepars_ids' *
                                        KK'=>' * V'Type' *
                       V'__Do'

    -- req
    , __extreq = (CK'input/output' + CK'output/input') * K'/delayed'
                   * OPT('[' * (V'__Exp'+Cc(true)) * KK']')
                   * V'__ID_ext'
* EE'TODO-PARSER: request'
    , _Ext_Req_proto = V'__extreq' * (V'Typepars_ids'+V'Typepars_anon') *
                                        KK'=>' * V'Type'
    , _Ext_Req_impl  = V'__extreq' * V'Typepars_ids' *
                                        KK'=>' * V'Type' *
                      V'__Do'

    -- TYPEPARS

    -- (var& int, var/nohold void&&)
    -- (var& int v, var/nohold void&& ptr)
    , __typepars_pre = CK'vector' * CKK'&' * V'__Dim'
                     + CK'pool'   * CKK'&' * V'__Dim'
                     + CK'event'  * CKK'&'
                     + CK'var'   * OPT(CKK'&') * OPT(KK'/'*CK'hold')

    , Typepars_ids_item  = V'__typepars_pre' * V'Type' * V'__ID_int'
    , Typepars_anon_item = V'__typepars_pre' * V'Type'

    , Typepars_ids = #KK'(' * (
                    PARENS(P'void') +
                    PARENS(V'Typepars_ids_item'   * (KK','*V'Typepars_ids_item')^0)
                  )
    , Typepars_anon = #KK'(' * (
                    PARENS(P'void') +
                    PARENS(V'Typepars_anon_item' * (KK','*V'Typepars_anon_item')^0)
                  )

-- DATA

    , __data       = K'data' * V'__ID_abs'
    , _Data_simple = V'__data'
    , _Data_block  = V'__data' * K'with' * (
                        (V'_Vars'+V'_Vecs'+V'_Pools'+V'_Evts') *
                            V'__seqs'
                     )^1 * K'end'

-- NATIVE, C, LUA

    -- C

    , _Nats  = K'native' *
                    OPT(KK'/'*(CK'pure'+CK'const'+CK'nohold'+CK'plain')) *
                        V'__ID_nat' * (KK',' * V'__ID_nat')^0
        --> Nat+

    , Nat_End = K'native' * KK'/' * K'end'
    , Nat_Block = K'native' * (CK'/pre'+CK'/pos') * (#K'do')*'do' *
                ( C(V'_C') + C((P(1)-(S'\t\n\r '*'end'*P';'^0*'\n'))^0) ) *
             x* K'end'

    , Nat_Stmt = KK'{' * C(V'__nat') * KK'}'
    , _Nat_Exp = KK'{' * C(V'__nat') * KK'}'
    , __nat   = ((1-S'{}') + '{'*V'__nat'*'}')^0

    -- Lua

    , _Lua     = KK'[' * m.Cg(P'='^0,'lua') * KK'[' *
                 ( V'__luaext' + C((P(1)-V'__luaext'-V'__luacmp')^1) )^0
                  * (V'__luacl'/function()end) *x
    , __luaext = P'@' * V'__Exp'
    , __luacl  = ']' * C(P'='^0) * KK']'
    , __luacmp = m.Cmt(V'__luacl' * m.Cb'lua',
                    function (s,i,a,b) return a == b end)

-- VARS, VECTORS, POOLS, VTS, EXTS

    -- DECLARATIONS

    , __vars_set  = V'__ID_int' * OPT(Ct(V'__Sets_one'+V'__Sets_many'))

    , _Vars_set  = K'var' * OPT(CKK'&') * V'Type' *
                    V'__vars_set' * (KK','*V'__vars_set')^0
    , _Vars      = K'var' * OPT(CKK'&') * V'Type' *
                    V'__ID_int' * (KK','*V'__ID_int')^0

    , _Vecs_set  = K'vector' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    V'__vars_set' * (KK','*V'__vars_set')^0
                        -- TODO: only vec constr
    , _Vecs      = K'vector' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    V'__ID_int' * (KK','*V'__ID_int')^0

    , _Pools_set = K'pool' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    V'__vars_set' * (KK','*V'__vars_set')^0
    , _Pools     = K'pool' * OPT(CKK'&') * V'__Dim' * V'Type' *
                    V'__ID_int' * (KK','*V'__ID_int')^0

    , _Evts_set  = K'event' * OPT(CKK'&') * (PARENS(V'Typelist')+V'Type') *
                    V'__vars_set' * (KK','*V'__vars_set')^0
    , _Evts      = K'event' * OPT(CKK'&') * (PARENS(V'Typelist')+V'Type') *
                    V'__ID_int' * (KK','*V'__ID_int')^0

    , _Exts      = (CK'input'+CK'output') * (PARENS(V'Typelist')+V'Type') *
                    V'__ID_ext' * (KK','*V'__ID_ext')^0
    , Typelist   = V'Type'   * (KK',' * V'Type')^0

-- AWAIT, EMIT

    , __Awaits_one  = K'await' * (V'Await_Wclock' + V'Abs_Await')
    , __Awaits_many = K'await' * V'Await_Until'

    , Await_Until  = (V'Await_Ext' + V'Await_Int') * OPT(K'until'*V'__Exp')
    , _Await_Until = (V'Await_Ext' + V'Await_Int') * Cc(false)

    , Await_Ext    = V'ID_ext' -I(V'Abs_Await') -- TODO: rem
    , Await_Int    = V'Exp_Name' -I(V'Await_Wclock'+V'Abs_Await') -- TODO: rem
    , Await_Wclock = (V'WCLOCKK' + V'WCLOCKE')

    , Await_Forever = K'await' * K'FOREVER'

    , _Emit_ps = OPT(KK'=>' * (V'__Exp' + PARENS(OPT(V'Explist'))))
    , Emit_Wclock   = K'emit' * (V'WCLOCKK'+V'WCLOCKE')
    , Emit_Ext_emit = K'emit'                     * V'ID_ext' * V'_Emit_ps'
    , Emit_Ext_call = (K'call/recursive'+K'call') * V'ID_ext' * V'_Emit_ps'
    , Emit_Ext_req  = K'request'                  * V'ID_ext' * V'_Emit_ps'
* EE'TODO-PARSER: request'

    , Emit_Evt = K'emit' * -#(V'WCLOCKK'+V'WCLOCKE') * V'Exp_Name' * V'_Emit_ps'

    , __watch = (V'_Await_Until' + V'Await_Wclock' + V'Abs_Await')
    , _Watching = K'watching' * V'__watch' * V'__Do'

    , __num = CKK(m.R'09'^1,'number') / tonumber
    , WCLOCKK = #V'__num' *
                (V'__num' * KK'h'   *x + Cc(0)) *
                (V'__num' * KK'min' *x + Cc(0)) *
                (V'__num' * KK's'   *x + Cc(0)) *
                (V'__num' * KK'ms'  *x + Cc(0)) *
                (V'__num' * KK'us'  *x + Cc(0))
                    * OPT(CK'/_')
    , WCLOCKE = PARENS(V'__Exp') * (
                    CK'h' + CK'min' + CK's' + CK'ms' + CK'us'
                  + E'<h,min,s,ms,us>'
              ) * OPT(CK'/_')

-- DETERMINISTIC

    , __det_id = V'ID_ext' + V'ID_int' + V'ID_nat'
    , Deterministic = K'deterministic' * V'__det_id' * (
                        K'with' * V'__det_id' * (KK',' * V'__det_id')^0
                      )^-1

-- ABS

    , __abs_call = (CK'call/recursive' + CK'call')
    , Abs_Call  = V'__abs_call' * V'__Abs_Cons_Code'
    , Abs_Val   = CK'val' * V'Abs_Cons'
    , Abs_New   = CK'new' * V'Abs_Cons'
    , Abs_Await = V'__Abs_Cons_Code'
    , Abs_Spawn = K'spawn' * V'__Abs_Cons_Code'

    , __Abs_Cons_Code = V'Abs_Cons' -I(V'__id_data')
    , Abs_Cons   = V'ID_abs' * PARENS(OPT(V'Abslist'))
    , Abslist    = ( V'__abs_item'*(KK','*V'__abs_item')^0 )^-1
    , __abs_item = (V'Abs_Cons' + V'Vec_Cons' + V'__Exp' + V'ID_any')


-- SETS

    , _Set = V'Exp_Name' * V'__Sets_one'
           + (V'Exp_Name' + PARENS(V'Namelist')) * V'__Sets_many'

    , __Sets_one  = (KK'='-'==') * (V'__sets_one'  + PARENS(V'__sets_one'))
    , __Sets_many = (KK'='-'==') * (V'__sets_many' + PARENS(V'__sets_many'))

    , __sets_one =
          V'_Set_Do'
        + V'_Set_Await_one'
        + V'_Set_Async_Thread'
        + V'_Set_Lua'
        + V'_Set_Vec'
        + V'_Set_Emit_Wclock'
        + V'_Set_Emit_Ext_emit' + V'_Set_Emit_Ext_call'
        + V'_Set_Abs_Val'
        + V'_Set_Abs_New'
        + V'_Set_Abs_Spawn'
        + V'_Set_Any'
        + V'_Set_Exp'

    , __sets_many = V'_Set_Emit_Ext_req' + V'_Set_Await_many' + V'_Set_Watching'

    -- after `=´

    , _Set_Do             = #K'do'            * V'Do'

    , _Set_Await_one      = #K'await'         * V'__Awaits_one'
    , _Set_Await_many     = #K'await'         * V'__Awaits_many'
    , _Set_Watching       = #K'watching'      * V'_Watching'

    , _Set_Async_Thread   = #K'async/thread'  * V'_Async_Thread'
    , _Set_Lua            = #V'__lua_pre'     * V'_Lua'
    , _Set_Vec            =                     V'Vec_Cons'

    , _Set_Emit_Wclock    = #K'emit'          * V'Emit_Wclock'
    , _Set_Emit_Ext_emit  = #K'emit'          * V'Emit_Ext_emit'
    , _Set_Emit_Ext_req   = #K'request'       * V'Emit_Ext_req'
    , _Set_Emit_Ext_call  = #V'__extcode_pre' * V'Emit_Ext_call'

    , _Set_Abs_Val        = #K'val'           * V'Abs_Val'
    , _Set_Abs_New        = #K'new'           * V'Abs_New'
    , _Set_Abs_Spawn      = #K'spawn'         * V'Abs_Spawn'

    , _Set_Any            = #K'_'             * V'ID_any'
    , _Set_Exp            =                     V'__Exp'

    , __extcode_pre = (K'call/recursive'+K'call') * V'ID_ext'
    , __lua_pre     = KK'[' * (P'='^0) * '['
    , __vec_pre     = KK'[' - V'__lua_pre'

    , __vec_concat = KK'..' * (V'__Exp' + V'_Lua' + #KK'['*V'Vec_Tup')
    , Vec_Tup  = V'__vec_pre' * OPT(V'Explist') * KK']'
    , Vec_Cons = V'__Exp'   * V'__vec_concat'^1
               + V'Vec_Tup' * V'__vec_concat'^0

-- IDS

    , ID_prim = V'__ID_prim'
    , ID_ext  = V'__ID_ext'
    , ID_int  = V'__ID_int'
    , ID_abs  = V'__ID_abs'
    , ID_nat  = V'__ID_nat'
    , ID_any  = V'__ID_any'

    , __ID_prim = CK(TYPES,                     'primitive type')
    , __ID_ext  = CK(m.R'AZ'*ALPHANUM^0  -KEYS, 'external identifier')
    , __ID_int  = CK(m.R'az'*Alphanum^0  -KEYS, 'internal identifier')
    , __ID_nat  = CK(P'_' * Alphanum^1,         'native identifier')
    , __ID_any  = CK(P'_' * -Alphanum,          '`_´')

    , __id_abs  = m.R'AZ'*V'__one_az' -KEYS
    , __id_data = V'__id_abs' * ('.' * V'__id_abs')^1
    , __ID_abs = CK(V'__id_data'+V'__id_abs', 'abstraction identifier')

    -- at least one lowercase character
    , __one_az = #(ALPHANUM^0*m.R'az') * Alphanum^0


-- MODS

    , __Dim = KK'[' * (V'__Exp'+Cc('[]')) * KK']'

-- LISTS

    , Namelist = V'Exp_Name' * (KK',' * V'Exp_Name')^0
    , Varlist  = V'ID_int'   * (KK',' * V'ID_int')^0
    , Explist  = V'__Exp'    * (KK',' * V'__Exp')^0

 --<<<

    , Kill  = K'kill' * V'Exp_Name' * OPT(KK'=>'*V'__Exp')

-- Types

    , Type = (V'ID_prim' + V'ID_abs' + V'ID_nat') * (CKK'&&')^0 * CKK'?'^-1

-- Expressions

    -- Exp_Name

    , Exp_Name   = V'__01_Name'
    , __01_Name  = (Cc('pre') * (CKK'*'+(CKK'$'-'$$')))^-1 * V'__02_Name'
    , __02_Name  = V'__03_Name' *
                    (Cc'pos' * (
                        KK'[' * Cc'idx' * V'__Exp' * KK']' +
                        (CKK':' + (CKK'.'-'..')) * (V'__ID_int'+V'__ID_nat') +
                        (CKK'!'-'!=') * Cc(false)
                      )
                    )^0
    , __03_Name  = PARENS(V'__01_Name' *
                    (CK'as' * (V'Type' + KK'/'*(CK'nohold'+CK'plain'+CK'pure')))^-1
                   )
                 + V'ID_int'  + V'ID_nat'
                 + V'Global'  + V'This'   + V'Outer'
                 + V'_Nat_Exp'

    -- Exp

    , __Exp  = V'__01'
    , __01   = V'__12' * ( CK'is' * V'Type'
                         + CK'as' * (V'Type' + KK'/'*(CK'nohold'+CK'plain'+CK'pure'))
                         )
             + V'__02'
    , __02   = V'__03' * (CK'or'  * V'__03')^0
    , __03   = V'__04' * (CK'and' * V'__04')^0
    , __04   = V'__05' * ( ( CKK'!='+CKK'=='+CKK'<='+CKK'>='
                           + (CKK'<'-'<<'-'<-')+(CKK'>'-'>>')
                           ) * V'__05'
                         )^0
    , __05   = V'__06' * ((CKK'|'-'||') * V'__06')^0
    , __06   = V'__07' * (CKK'^' * V'__07')^0
    , __07   = V'__08' * ((CKK'&'-'&&') * V'__08')^0
    , __08   = V'__09' * ((CKK'>>'+CKK'<<') * V'__09')^0
    , __09   = V'__10' * ((CKK'+'+(CKK'-'-'->')) * V'__10')^0
    , __10   = V'__11' * ((CKK'*'+(CKK'/'-'//'-'/*')+CKK'%') * V'__11')^0
    , __11   = ( Cc('pre') *
                    ( CK'not'+(CKK'-'-'->')+CKK'+'+CKK'~'+CKK'$$' )
               )^0 * V'__12'
    , __12   = V'Exp_Call'  -- TODO: ambiguous w/ PARENS,Name
             + V'Abs_Call'
             + V'Exp_Name' * (Cc'pos' * (CKK'?' * Cc(false)))^-1
             + Cc('pre') * CKK'&&'       * V'Exp_Name'
             + Cc('pre') * (CKK'&'-'&&') * (V'Exp_Call'+V'Exp_Name')
             + PARENS(V'__Exp')
             + V'SIZEOF'
             + V'NULL' + V'NUMBER' + V'BOOL' + V'STRING'

    , SIZEOF = K'sizeof' * PARENS((V'Type' + V'__Exp'))

    , NUMBER = CK( #m.R'09' * (m.R'09'+S'xX'+m.R'AF'+m.R'af'+(P'.'-'..')
                                      +(S'Ee'*'-')+S'Ee')^1,
                   'number' )
             --+ CKK( "'" * (P(1)-"'")^0 * "'" , 'number' )

    , BOOL   = K'false' / function() return 0 end
             + K'true'  / function() return 1 end
    , STRING = CKK( CKK'"' * (P(1)-'"'-'\n')^0 * K'"', 'string literal' )
    , NULL   = CK'null'     -- TODO: the idea is to get rid of this

    , Global  = K'global'
    , This    = K'this' * Cc(false)
    , Outer   = K'outer'

    , __exp_call = (CK'call/recursive' + CK'call' + Cc'call')
    , Exp_Call = V'__exp_call' * (V'Exp_Name'+PARENS(V'__Exp')) *
                                PARENS(OPT(V'Explist'))

---------
                -- "Ct" as a special case to avoid "too many captures" (HACK_1)
    , _Stmts  = Ct (( V'__Stmt_Simple' * V'__seqs' +
                      V'__Stmt_Block' * (KK';'^0)
                   )^0
                 * ( V'__Stmt_Last' * V'__seqs' +
                     V'__Stmt_Last_Block' * (KK';'^0)
                   )^-1
                 * (V'Nat_Block'+V'_Code_impl')^0 )

    , __Stmt_Last  = V'_Escape' + V'Break' + V'Continue' + V'Await_Forever'
    , __Stmt_Last_Block = V'Par'
    , __Stmt_Simple = V'Nothing'
                    + V'_Vars_set'  + V'_Vars'
                    + V'_Vecs_set'  + V'_Vecs'
                    + V'_Pools_set' + V'_Pools'
                    + V'_Evts_set'  + V'_Evts'
                    + V'_Exts'
                    + V'_Data_simple'
                    + V'_Code_proto' + V'_Ext_Code_proto' + V'_Ext_Req_proto'
                    + V'_Nats'  + V'Nat_End'
                    + V'Deterministic'
                    + V'_Set'
                    + V'__Awaits_one' + V'__Awaits_many'
                    + V'Emit_Wclock'
                    + V'Emit_Ext_emit' + V'Emit_Ext_call' + V'Emit_Ext_req'
                    + V'Emit_Evt'
                    + V'Abs_Spawn' + V'Kill'
-- TODO: remove class/interface
+ I((K'class'+K'interface'+K'traverse')) * EE'TODO-PARSER: class/interface'
                    + V'Stmt_Call'
                    + V'Nat_Stmt'

    , __Stmt_Block = V'_Code_impl' + V'_Ext_Code_impl' + V'_Ext_Req_impl'
              + V'_Data_block'
              + V'Nat_Block'
              + V'Do'    + V'_If'
              + V'Loop' + V'_Loop_Num' + V'_Loop_Pool'
              + V'_Every'
              + V'_Spawn_Block'
              + V'Finalize'
              + V'Par_Or' + V'Par_And' + V'_Watching'
              + V'Pause_If'
              + V'Async' + V'_Async_Thread' + V'_Async_Isr' + V'Atomic'
              + V'_Dopre'
              + V'_Lua'
              + V'_Var_set_fin'

    --, _C = '/******/' * (P(1)-'/******/')^0 * '/******/'
    , _C      = m.Cg(V'_CSEP','mark') *
                    (P(1)-V'_CEND')^0 *
                V'_CEND'
    , _CSEP = '/***' * (1-P'***/')^0 * '***/'
    , _CEND = m.Cmt(C(V'_CSEP') * m.Cb'mark',
                    function (s,i,a,b) return a == b end)

    , __SPACE = ('\n' * (V'__comm'+S'\t\n\r ')^0 *
                  '#' * (P(1)-'\n')^0)
              + ('//' * (P(1)-'\n')^0)
              + S'\t\n\r '
              + V'__comm'

    , __comm    = '/' * m.Cg(P'*'^1,'comm') * (P(1)-V'__commcmp')^0 * 
                    V'__commcl'
                    / function () end
    , __commcl  = C(P'*'^1) * '/'
    , __commcmp = m.Cmt(V'__commcl' * m.Cb'comm',
                    function (s,i,a,b) return a == b end)

}

if RUNTESTS then
    assert(m.P(GG):match(CEU.source), ERR())
else
    if not m.P(GG):match(CEU.source) then
             -- TODO: match only in ast.lua?
        DBG(ERR())
        os.exit(1)
    end
end

local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node

local context = {
  trig = 'faroute',
  name = 'faroute',
  desc = 'FastAPI Route Function',
  wordTrig = true,
  regTrig = false,
  trigEngine = 'plain',
  hidden = false,
  snippetType = 'snippet',
}
local nodes = {
  t '@',
  i(1, 'router'),
  t '.',
  c(2, {
    t 'get',
    t 'post',
    t 'put',
    t 'delete',
    t 'patch',
  }),
  t '("/',
  i(3, 'api/endpoint'),
  t '")',
  t { '', '' }, -- newline
  t { 'async def ' },
  i(4, 'function'),
  t '(',
  i(5, 'args'),
  t { '):' },
  t { '', '\t' }, -- newline + indent
  i(0, 'pass'), -- last placeholder, exit point
}
local snippet = s(context, nodes)

return {
  snippet,
}, {}

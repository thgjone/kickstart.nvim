local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Extract parameter names from function signature
local function get_params()
  -- get the current line above the cursor
  local line = vim.fn.getline '.'
  -- match function parameters: (...), allow spaces
  local params_str = line:match '%((.*)%)'
  if not params_str or params_str == '' then return {} end
  local params = {}
  for param in params_str:gmatch '[^,]+' do
    local name = param:match '(%w+)%s*$' -- last word in param
    if name then table.insert(params, name) end
  end

  local nodes = {}
  for _, p in ipairs(params) do
    table.insert(nodes, t { '/// <param name="' .. p .. '">' })
    table.insert(nodes, i(#nodes + 1))
    table.insert(nodes, t { '</param>' })
    table.insert(nodes, t { '' })
  end
  return nodes
end

-- snippet
ls.add_snippets('cs', {
  s('doc', {
    t { '/// <summary>', '/// ' },
    i(1, 'Description'),
    t { '', '/// </summary>' },
    f(function() return get_params() end, {}),
    t { '/// <returns>' },
    i(0),
    t { '</returns>' },
  }),
})

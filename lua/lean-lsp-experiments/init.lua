local lsp = require 'lean.lsp'
local edit = require('lean-lsp-experiments.edit')
local select = require('lean-lsp-experiments.select')

local async = require 'plenary.async'

local open = require 'lean.rpc'.open

local rpc = require'lean-lsp-experiments.rpc'
local notify = require("notify")

local LeanLspExperiments = {}

function string:split(delimiter)
  local result = { }
  local from  = 1
  local delim_from, delim_to = string.find( self, delimiter, from  )
  while delim_from do
    table.insert( result, string.sub( self, from , delim_from-1 ) )
    from  = delim_to + 1
    delim_from, delim_to = string.find( self, delimiter, from  )
  end
  table.insert( result, string.sub( self, from  ) )
  return result
end

local function getStack(window, sess)
  window = window or 0
  local params = vim.lsp.util.make_position_params(window)
  sess = sess or open(params)

  async.void(function()
    local result = rpc.syntaxStackAt(sess, params)
    if not result then
      return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, result:split("\n"))
    local opts = {split='right'}
    vim.api.nvim_open_win(buf, 0, opts)
    -- " optional: change highlight, otherwise Pmenu is used
    -- call nvim_set_option_value('winhl', 'Normal:MyHighlight', {'win': win})
  end)()
end


vim.keymap.set('n', '[m', edit.declaration.goto_start, {
  buffer = true,
  desc = 'Move to the previous declaration start.',
})

vim.keymap.set('n', ']m', edit.declaration.goto_end, {
  buffer = true,
  desc = 'Move to the next declaration end.',
})

vim.keymap.set('n', 'DS', getStack, {
  buffer = true,
  desc = 'Debug Lean syntax stack.',
})

vim.keymap.set('n', 'SD', select.declaration, {
  buffer = true,
  desc = 'Select current declaration.',
})

vim.keymap.set('n', 'SA', select.at, {
  buffer = true,
  desc = 'Select current syntax.',
})

vim.keymap.set('v', 'A', select.around, {
  buffer = true,
  desc = 'Extend current syntax selection.',
})
vim.keymap.set('v', 'S', select.stackAround, {
  buffer = true,
  desc = 'Debug syntax stack around current visual selection.',
})

return LeanLspExperiments

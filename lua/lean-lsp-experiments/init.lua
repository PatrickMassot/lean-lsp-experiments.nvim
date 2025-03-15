local lsp = require 'lean.lsp'
local edit = require('lean-lsp-experiments.edit')

local LeanLspExperiments = {}

local function hello()
  print("Hello")
end

vim.keymap.set('n', '[m', edit.declaration.goto_start, {
  buffer = true,
  desc = 'Move to the previous declaration start.',
})

vim.keymap.set('n', ']m', edit.declaration.goto_end, {
  buffer = true,
  desc = 'Move to the next declaration end.',
})

LeanLspExperiments.hello = hello

return LeanLspExperiments

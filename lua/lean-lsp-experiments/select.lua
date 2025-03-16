local async = require 'plenary.async'

local open = require 'lean.rpc'.open

local rpc = require'lean-lsp-experiments.rpc'

local notify = require("notify")

local select = {
}

local function select_range(window, range)
  window = window or 0
  local line = range.start.line + 1
  local character = range.start.character
  vim.api.nvim_win_set_cursor(window, { line, character })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("v", true, false, true), 'x', false)
  vim.api.nvim_win_set_cursor(window, {
    range['end'].line + 1,
    range['end'].character,
    })
end

function select.declaration(window, sess)
  window = window or 0
  local params = vim.lsp.util.make_position_params(window)
  sess = sess or open(params)

  async.void(function()
    local result = rpc.declarationRangeAt(sess, params)
    if not result then
      return
    end
    select_range(window, result)
  end)()
end

function select.at(window, sess)
  window = window or 0
  local params = vim.lsp.util.make_position_params(window)
  sess = sess or open(params)

  async.void(function()
    local result = rpc.syntaxAt(sess, params)
    if not result then
      return
    end
    select_range(window, result)
  end)()
end

function select.stackAround(window, sess)
  window = window or 0
  -- Will now try to get current visual selection. Wrong if selected from right
  -- to left.
  -- local params = vim.lsp.util.make_range_params(window)
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  local params = vim.lsp.util.make_given_range_params({ls, cs}, {le, ce})
  -- notify(vim.inspect(params.range))
  sess = sess or open(vim.lsp.util.make_position_params(window))
  async.void(function()
    local result = rpc.syntaxStackAround(sess, params.range)
    notify(vim.inspect(result))
    if not result then
      print("No result")
      return
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, result:split("\n"))
    local opts = {split='right'}
    vim.api.nvim_open_win(buf, 0, opts)
    -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), 'x', false)
    -- select_range(window, result)
  end)()
end

function select.around(window, sess)
  window = window or 0
  -- Will now try to get current visual selection. Wrong if selected from right
  -- to left.
  -- local params = vim.lsp.util.make_range_params(window)
  local _, ls, cs = unpack(vim.fn.getpos('v'))
  local _, le, ce = unpack(vim.fn.getpos('.'))
  local params = vim.lsp.util.make_given_range_params({ls, cs}, {le, ce})
  -- notify(vim.inspect(params.range))
  sess = sess or open(vim.lsp.util.make_position_params(window))
  async.void(function()
    local result = rpc.syntaxAround(sess, params.range)
    notify(vim.inspect(result))
    if not result then
      print("No result")
      return
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<ESC>", true, false, true), 'x', false)
    select_range(window, result)
  end)()
end

return select

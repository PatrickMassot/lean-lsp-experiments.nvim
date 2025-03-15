local lsp = require 'lean.lsp'
local Subsession = require('lean.rpc').Subsession
local edit = require('lean-lsp-experiments.edit')


---@param subsession any
---@param pos lsp.TextDocumentPositionParams
---@return InteractiveGoals goals
---@return LspError error
local function declarationRangeAt(subsession,pos)
  return subsession:call('rpcDeclarationRangeAt', pos)
end

local LeanLspExperiments = {}

local function hello()
  print("Hello")
end

LeanLspExperiments.hello = hello
LeanLspExperiments.declarationRangeAt = declarationRangeAt

return LeanLspExperiments

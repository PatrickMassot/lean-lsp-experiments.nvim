local lsp = require 'lean.lsp'
local Subsession = require('lean.rpc').Subsession
local edit = require('lean-lsp-experiments.edit')


---@param pos lsp.TextDocumentPositionParams
---@return InteractiveGoals goals
---@return LspError error
function Subsession:declarationRangeAt(pos)
  return self:call('rpcDeclarationRangeAt', pos)
end

local LeanLspExperiments = {}

local function hello()
  print("Hello")
end

LeanLspExperiments.hello = hello


return LeanLspExperiments

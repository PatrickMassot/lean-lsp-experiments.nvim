local rpc = {}

---@param subsession any
---@param pos lsp.TextDocumentPositionParams
---@return InteractiveGoals goals
---@return LspError error
function rpc.declarationRangeAt(subsession,pos)
  return subsession:call('rpcDeclarationRangeAt', pos)
end

return rpc

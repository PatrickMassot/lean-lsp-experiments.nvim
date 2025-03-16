local rpc = {}

---@param subsession any
---@param pos lsp.TextDocumentPositionParams
---@return InteractiveGoals goals
---@return LspError error
function rpc.declarationRangeAt(subsession, pos)
  return subsession:call('rpcDeclarationRangeAt', pos)
end

function rpc.syntaxStackAt(subsession, pos)
  return subsession:call('syntaxStack', pos)
end

function rpc.syntaxAt(subsession, pos)
  return subsession:call('rpcSyntaxAt', pos)
end

function rpc.syntaxStackAround(subsession, range)
  return subsession:call('rpcSyntaxStackAround', range)
end

function rpc.syntaxAround(subsession, range)
  return subsession:call('rpcSyntaxAround', range)
end

return rpc

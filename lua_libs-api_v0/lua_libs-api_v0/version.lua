local rpc_version = _envlibrequire("rpc_version")

local version = {
  rpc = rpc_version.rpc,
  api = 0,
}

return version

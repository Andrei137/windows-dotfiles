local M = {}

local function get_details(pane)
  local cwd_str = tostring(pane:get_current_working_dir()) or nil
  local proc = pane:get_foreground_process_name() or ""
  local is_wsl = proc:lower():find("wslhost.exe")

  return cwd_str, is_wsl
end

local function get_cwd(cwd_str, is_wsl)
  local cwd
  if not cwd_str then
    cwd = is_wsl and "~" or nil
  elseif is_wsl then
    cwd = cwd_str:gsub("^file://[^/]+", "")
    cwd = cwd ~= "" and cwd or "~"
  else
    cwd = cwd_str:gsub("^file:///", "")
    cwd = cwd ~= "" and cwd or nil
  end

  return cwd
end

function M.keep_domain(pane)
  local cwd_str, is_wsl = get_details(pane)

  return is_wsl and { DomainName = "WSL:Ubuntu" } or "DefaultDomain", get_cwd(cwd_str, is_wsl)
end

function M.reverse_domain(pane)
  local cwd_str, is_wsl = get_details(pane)

  return is_wsl and "DefaultDomain" or { DomainName = "WSL:Ubuntu" }, get_cwd(cwd_str, is_wsl)
end

function M.startup(mux, cmd)
  local position = 120
  local tab, pane, window = mux.spawn_window(cmd or
    { position={ x=position,y=position } }
  )
end

return M
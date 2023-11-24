local util = require("xcodebuild.util")
local notifications = require("xcodebuild.notifications")
local appdata = require("xcodebuild.appdata")

local M = {}

function M.save_failing_snapshots(reportPath, callback)
  local savePath = appdata.snapshots_dir
  local getsnapshotPath = appdata.tool_path(GETSNAPSHOTS_TOOL)
  local command = getsnapshotPath .. " '" .. reportPath .. "' '" .. savePath .. "'"

  util.shell("mkdir -p '" .. savePath .. "'")

  return vim.fn.jobstart(command, {
    on_exit = function(_, code)
      if code == 0 then
        if callback then
          callback()
        end
      else
        notifications.send_error(
          "Saving snapshots failed. Make sure that you have this file: " .. getsnapshotPath
        )
      end
    end,
  })
end

function M.get_failing_snapshots()
  return util.filter(
    util.shell("find '" .. appdata.snapshots_dir .. "' -type f -iname '*.png'"),
    function(item)
      return item ~= ""
    end
  )
end

function M.delete_snapshots()
  util.shell("rm -rf '" .. appdata.snapshots_dir .. "'")
end

return M
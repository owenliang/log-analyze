local _M = {}

local file = nil 
local file_path = ''
local file_idx = 0

local function build_file_path(ts)
    return ngx.var.collect_path .. "/collect." .. os.date("%Y%m%d%H", ts) .. ".log"
end

function _M.rotate_file()
    local now = os.time()
    local nex_idx = math.floor(now / 3600)

    -- 判断是否需要轮转文件
    if file and nex_idx == file_idx then
        return 
    end

    -- 打开新文件
    local new_path = build_file_path(now)
    local new_file = io.open(new_path, 'a')
    if not new_file then -- 打开失败, 则保持旧文件继续写入
        return 
    end

    -- 关闭新文件
    if file then 
        file:close()
    end

    -- 替换为新文件
    file = new_file
    file_path = new_path
    file_idx = new_idx
end

function _M.write(msg) 
    _M.rotate_file()

    if not file then
        ngx.log(ngx.ERR, '文件无法打开: ' .. file_path)
        return
    end

    file:write(msg .. '\n')
    file:flush()
end

return _M
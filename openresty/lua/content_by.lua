local log = require("log")
local json = require("cjson")

-- 读取body
local raw_msg = ngx.req.get_body_data()
if not raw_msg or string.len(raw_msg) == 0 then -- 上报内容为空, 直接返回
    ngx.exit(ngx.HTTP_OK) 
    return
end

-- json数组解开为多条日志
local raw_arr = json.decode(raw_msg)
local log_arr = {} -- 拆分后的json行数组
for idx, log_item in pairs(raw_arr) do 
    log_item.ip = ngx.var.remote_addr
    local log_item_str = json.encode(log_item)
    table.insert(log_arr, log_item_str)
end

-- 结束应答, 在log_by_lua_file阶段输出日志
ngx.ctx.log_arr = log_arr
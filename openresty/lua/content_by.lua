local log = require("log") -- 自定义log库
local json = require("cjson") -- json库
local ck = require("resty.cookie") -- cookie库

-- 读取日志list
local post_args = ngx.req.get_post_args()
if not post_args or not post_args["list"] then -- 上报内容为空, 直接返回
    ngx.exit(ngx.HTTP_OK) 
    return
end

local raw_list = post_args["list"]

-- 解析cookie
local cookie, err = ck:new()
if not cookie then
    ngx.log(ngx.ERR, err)
    return
end

-- 获取cookie
local all_cookies, err = cookie:get_all()
if not all_cookies then
    all_cookies = {}
end
-- 为cookie进行urldecode
for cname, cvalue in pairs(all_cookies) do
    all_cookies[cname] = ngx.unescape_uri(cvalue)
end

-- json数组解开为多条日志
local raw_arr = json.decode(raw_list)

-- 重组日志
local log_arr = {} -- 拆分后的json行数组
for idx, log_item in pairs(raw_arr) do 
    -- 将cookie合并到日志行中
    for cname, cvalue in pairs(all_cookies) do
        log_item[cname] = cvalue
    end
    -- 序列化日志行, 放入待输出数组
    local log_item_str = json.encode(log_item)
    table.insert(log_arr, log_item_str)
end

-- 结束应答, 在log_by_lua_file阶段输出日志
ngx.ctx.log_arr = log_arr
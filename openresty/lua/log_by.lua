local log = require("log")

-- 将日志顺序写到磁盘上
for _, log_item in ipairs(ngx.ctx.log_arr) do 
    log.write(log_item)
end

-- 批量刷出到磁盘
log.flush()
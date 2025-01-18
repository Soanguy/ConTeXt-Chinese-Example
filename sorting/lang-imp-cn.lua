local function whatever(name)
    local data = io.loaddata(name)
    if data then
        local mapping = { }
        for a, b in string.gmatch(data,".-: ([^, ]+).-# (%S+)") do -- U+4E00: yī  # 一
            mapping[b] = a
        end
        return mapping
    end
end

return {
    name = "cn transliterations",
    transliterations = {
        ["hanyu to pinlu"] = {
            mapping = whatever("pinyin.txt")
        }
    }
}

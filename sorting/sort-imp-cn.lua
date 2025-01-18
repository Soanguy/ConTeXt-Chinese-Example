local utfchar, utfbyte  = utf.char, utf.byte
local sorters           = sorters or { }
local definitions       = sorters.definitions or { }
local replacementoffset = sorters.constants.replacementoffset
local variables         = interfaces.variables or { }

local function splitedPinyin(name)
    local data = io.loaddata(name)
    if data then
        local replacements = { }
        for a, b in string.gmatch(data,".-: ([^, ]+).-# (%S+)") do -- U+4E00: yī  # 一
            replacements[#replacements+1] = { b, a }
        end
        return replacements
    end
end

-- %%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%

local function load_pinyin(name)
    local data = io.loaddata(name)
    local entries = {}

    for line in string.gmatch(data, "([^\r\n]+)") do
        local character, pinyin = line:match(".-: ([^, ]+).-# (%S+)")
        if character and pinyin then
            table.insert(entries, { character, pinyin })
        end
    end

    return entries
end

local function sort_by_pinyin(entries)
    table.sort(entries, function(a, b)
        return a[1] < b[1]
    end)
    return entries
end

local function get_sorted_pinyin(name)
    local entries = load_pinyin(name)
    entries = sort_by_pinyin(entries)
    local pinyin_list = {}

    for _, entry in ipairs(entries) do
        if entry[2] then
            table.insert(pinyin_list, '"' .. entry[2] .. '"')
        end
    end

    return table.concat(pinyin_list, ',')
end

local sortedPinyin = get_sorted_pinyin('pinyin.txt')

definitions['cn-hanzis'] = {
    entries = {
        ['a'] = 'alpha', ['b'] = 'alpha', 
        ['c'] = 'alpha', ['d'] = 'alpha', 
        ['e'] = 'alpha'
      },
    orders = {get_sorted_pinyin('pinyin.txt')},
    -- replacements = sorters.replacementlist(get_sorted_pinyin('pinyin.txt'))
}

-- %%%%%%%%%%%%%%%
-- %%%%%%%%%%%%%%%

definitions["cn-alphas"] = {
 -- orders = { },
    replacements = splitedPinyin("pinyin.txt"),
}



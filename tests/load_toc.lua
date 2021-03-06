for line in io.lines(...) do
    local first = line:sub(1, 1)
    if first ~= '#' and line:len() > 1 then
        line = line:gsub('\\', '/')
        line = line:gsub('lua.*', 'lua')
        local file_path = '../' .. line
        local file = loadfile(file_path)
        if file ~= nil then
            --print('Loaded ' .. file_path)
            file()
        else
            error('Unable to load file ' .. file_path)
        end
    end
end
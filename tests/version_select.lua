if os.getenv('CLASSIC_VERSION') ~= nil then
    print('Running tests for WoW Classic')
    function _G.GetBuildInfo()
        return "1.13.2", 32600, "Nov 20 2019", 11302
    end
    loadfile('profession_api_classic.lua')()
else
    print('Running tests for WoW Retail')
    function _G.GetBuildInfo()
        return "9.0.2", 37474, "Feb 3 2021", 90002
    end
    loadfile('profession_api_retail.lua')()

    --TODO: Test should be skipped, this function does not exist in WoW Retail
    function _G.GetNumTradeSkills()
        return 2
    end
end
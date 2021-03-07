local lu = require('luaunit')

loadfile('wow_functions.lua')()

if os.getenv('CLASSIC_VERSION') ~= '' then
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

loadfile('build_utils/utils/load_toc.lua')('../LibProfessions.toc')

_G['test'] = {}
local test = _G['test']

local api = _G['ProfessionAPI']

function test:testIsReady()
    lu.assertTrue(api:IsReady())
end

function test:testNumRecipes()
    lu.assertEquals(2, api:NumRecipes())
end

function test:testNumReagents()
    lu.assertEquals(3, api:NumReagents(3447))
end

function test:testGetReagentItemLink()
    local link = "\124cffffffff\124Hitem:2453::::::::60:::::\124h[Bruiseweed]\124h\124r";
    lu.assertEquals(link, api:GetReagentItemLink(3447, 1))
end

function test:testGetReagentInfo()
    local reagentName, reagentTexture, reagentCount, playerReagentCount = api:GetReagentInfo(3447, 1)
    lu.assertEquals('Bruiseweed', reagentName)
    lu.assertEquals('inv_misc_herb_01', reagentTexture)
    lu.assertEquals(1, reagentCount)
    lu.assertEquals(20, playerReagentCount)
end

os.exit(lu.LuaUnit.run())
local lu = require('luaunit')
loadfile('load.lua')()

_G['test'] = {}
local test = _G['test']

---@type LibProfessions
local lib = _G['LibProfessions-@project-version@']
---@type LibProfessionAPI
local api = lib.api

function test:testIsReady()
    lu.assertTrue(api:IsReady())
end

function test:testGetInfo()
    local skillLineName, skillLineRank, skillLineMaxRank = api:GetInfo()

    lu.assertEquals('Alchemy', skillLineName)
    lu.assertEquals(10, skillLineRank)
    lu.assertEquals(125, skillLineMaxRank)

    return skillLineName, skillLineRank, skillLineMaxRank
end

function test:testNumRecipes()
    if lib.is_classic then
        lu.assertEquals(api:NumRecipes(), 2)
    else
        lu.assertEquals(api:NumRecipes(), 1)
    end
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
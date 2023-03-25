local lu = require('luaunit')
loadfile('load.lua')()

_G['test'] = {}
local test = _G['test']

---@type LibProfessions
local base = _G.LibStub("LibProfessions-0")
local lib = base.currentProfession

function test:testGetReagents()
    local reagents = lib:GetReagents(3447) --Healing Potion
    lu.assertNotNil(reagents, 'No reagents found')
    lu.assertEquals(reagents[1]['reagentItemID'], 2453)
    lu.assertEquals(reagents[1]['reagentName'], 'Bruiseweed')
    lu.assertEquals(reagents[2]['reagentItemID'], 2450)
    lu.assertEquals(reagents[2]['reagentName'], 'Briarthorn')
    if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then
        lu.assertEquals(reagents[3]['reagentItemID'], 3371)
        lu.assertEquals(reagents[3]['reagentName'], 'Crystal Vial')
    else
        lu.assertEquals(reagents[3]['reagentItemID'], 3372)
        lu.assertEquals(reagents[3]['reagentName'], 'Leaded Vial')
    end
end

function test:testGetRecipes()
    local recipes = lib:GetRecipes()
    lu.assertNotNil(recipes)
    local key

    if base.is_classic then
        key = 1
    else
        key = 3447
    end

    lu.assertNotNil(recipes[key])
    lu.assertEquals('Healing Potion', recipes[key]['name'])
end

os.exit(lu.LuaUnit.run())
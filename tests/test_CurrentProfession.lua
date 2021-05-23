local lu = require('luaunit')
loadfile('load.lua')()

_G['test'] = {}
local test = _G['test']

---@type LibProfessions
local base = _G.LibStub("LibProfessions-0")
local lib = base.currentProfession

function test:testGetReagents()
    local reagents = lib:GetReagents(3447)
    lu.assertNotNil(reagents)
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
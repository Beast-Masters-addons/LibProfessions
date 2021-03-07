_G['test'] = {}
local test = _G['test']

local lu = require('luaunit')

loadfile('wow_functions.lua')()
loadfile('version_select.lua')()

loadfile('build_utils/utils/load_toc.lua')('../LibProfessions.toc')

local lib = _G['CurrentProfession']

function test:testGetReagents()
    local reagents = lib:GetReagents(3447)
    lu.assertNotNil(reagents)
end

function test:testGetRecipes()
    local recipes = lib:GetRecipes()
    lu.assertNotNil(recipes)
    lu.assertNotNil(recipes[3447])
end

os.exit(lu.LuaUnit.run())
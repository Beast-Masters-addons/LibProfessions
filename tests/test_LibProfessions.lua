local lu = require('luaunit')
loadfile('load.lua')()

_G['test'] = {}
local test = _G['test']
---@type LibProfessions
local lib = _G['LibProfessions-@project-version@']

_G.C_Spell = {}
function _G.C_Spell.DoesSpellExist()
    return true
end

function test:testVersion()
    if os.getenv('GAME_VERSION') == 'retail' then
        lu.assertEquals(lib.is_classic, false)
        lu.assertEquals(lib.is_classic_era, false)
        lu.assertEquals(lib.is_wrath, false)
    elseif os.getenv('GAME_VERSION') == 'wrath' then
        lu.assertEquals(lib.is_classic, true)
        lu.assertEquals(lib.is_classic_era, false)
        lu.assertEquals(lib.is_wrath, true)
    elseif os.getenv('GAME_VERSION') == 'classic' then
        lu.assertEquals(lib.is_classic, true)
        lu.assertEquals(lib.is_classic_era, true)
        lu.assertEquals(lib.is_wrath, false)
    else
        error('Invalid value for GAME_VERSION: ' .. os.getenv('GAME_VERSION'))
    end
end

function test:testLibraries()
    lu.assertNotNil(lib.version)
    lu.assertNotNil(lib.api)
    lu.assertNotNil(lib.currentProfession)
end

function test:testIcon()
    lu.assertEquals(lib:iconId('Blacksmithing'), 136241)
    lu.assertEquals(lib:iconFile('Blacksmithing'), 'trade_blacksmithing')
end

function test:testProfessionId()
    lu.assertEquals(lib:profession_id('Alchemy', 1), 2259)
    if lib.is_classic then
        lu.assertEquals(lib:profession_id('Alchemy', 9), nil)
    end
end

function test:testGetAllSkillsNoFilter()
    if not lib.is_classic then
        return
    end
    local skills = lib:GetAllSkills()
    lu.assertNotNil(skills['Fishing'])
    lu.assertNotNil(skills['Herbalism'])
    lu.assertNotNil(skills['Feral Combat'])
end

function test:testGetSecondarySkills()
    if not lib.is_classic then
        return
    end
    local skills = lib:GetAllSkills('Secondary Skills')
    lu.assertNotNil(skills['Fishing'])
    lu.assertNil(skills['Herbalism'])
    lu.assertNil(skills['Feral Combat'])
end

function test:testGetAllProfessions()
    if not lib.is_classic then
        return
    end
    local skills = lib:GetAllSkills({ 'Professions', 'Secondary Skills' })
    lu.assertNotNil(skills['Fishing'])
    lu.assertNotNil(skills['Herbalism'])
    lu.assertNil(skills['Feral Combat'])
end

function test:testGetProfessions()
    local professions = lib:GetProfessions()
    lu.assertEquals(type(professions), 'table')
    if not lib.is_classic then
        lu.assertNotNil(professions['Leatherworking'])
    else
        lu.assertNotNil(professions['Alchemy'])
    end
end

function test:testGetSkill()
    if  lib.is_classic then
        local profession = lib:GetSkill('Alchemy')
        lu.assertEquals(profession['name'], 'Alchemy')
        lu.assertEquals(profession['skill'], 132)
        lu.assertEquals(profession['max_skill'], 150)
    else
        local profession = lib:GetSkill('Leatherworking')
        lu.assertEquals(profession['name'], 'Leatherworking')
        lu.assertEquals(profession['skill'], 65)
        lu.assertEquals(profession['max_skill'], 100)
    end
end


os.exit(lu.LuaUnit.run())
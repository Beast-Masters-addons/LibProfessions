---A library to get information about the characters professions
_G['LibProfessions'] = {}
local lib = _G['LibProfessions']
lib.version = '@project-version@'
lib.utils = _G['BMUtils']
local utils = _G['BMUtils']
lib.api = _G['LibProfessionsAPI-@project-version@']
lib.currentProfession = _G['LibProfessionsCurrentProfession-@project-version@']
local common = _G['LibProfessionsCommon-@project-version@']
local WoWClassic = common.is_classic

if _G['LibStub'] then
    local major, minor = _G['BMUtils-Version'].parse_version(lib.version)
    lib = _G['LibStub']:NewLibrary("LibProfessions-"..major, minor)
    utils = _G.LibStub("BM-utils-1")
end

if not lib then
    -- luacov: disable
    return	-- already loaded and no upgrade necessary
    -- luacov: enable
end

--/dump LibStub("LibProfessions-1.0"):profession_id("Leatherworking")
--local addonName, professions = ...

local icons = {
    ["Blacksmithing"] = {136241, 'trade_blacksmithing'},
    ["Leatherworking"] = {133611, 'inv_misc_armorkit_17'},
    ["Skinning"] = {134366, 'inv_misc_pelt_wolf_01'}
}

local professions_bfa = {
    ["Alchemy"] = 2259,
    ["Blacksmithing"] = 3100,
    ["Enchanting"] = 7411,
    ["Engineering"] = 4036,
    ["Inscription"] = 45357,
    ["Jewelcrafting"] = 25229,
    ["Leatherworking"] = 2108,
    ["Tailoring"] = 3908,
    ["Skinning"] = 8617,
    ["Mining"] = 2575,
    ["Herbalism"] = 2366,
    ["Smelting"] = 2656,
    ["Cooking"] = 3102,
    ["Fishing"] = 7731,
}

local professions_classic = {
    ["Alchemy"] = {2259,3101,3464,11611},
    ["Blacksmithing"] = {2018,3100,3538,9785},
    ["Enchanting"] = {},
    ["Engineering"] = {},
    ["Leatherworking"] = {2108,3104,3811},
    ["Tailoring"] = {3908},
    ["Skinning"] = {8613,8617,8618,10768},
    ["Mining"] = {2575,2576,3564,10248},
    ["Herbalism"] = {},
    ["Smelting"] = {},
    ["Cooking"] = {2550,3102,3413,18260},
    ["Fishing"] = {7620,7731,7732,18248},
}

local rank_max = {[75] = "Apprentice",
                  [150] = "Journeyman",
                  [225] = "Expert",
                  [300] = "Artisan"}

function lib:icon(profession_name)
    return icons[profession_name][1]
end

function lib:profession_id(profession_name, rank)
    if rank == nil then
       rank = 1
    end
    local spellID
    if WoWClassic then
        spellID =  professions_classic[profession_name][rank]
    else
        spellID = professions_bfa[profession_name][rank]
    end
    local spellExists = _G.C_Spell.DoesSpellExist(spellID)

    if spellExists then
        return spellID
    else
        return
    end
end

function lib:profession_name()
    --GetSpellInfo
end

--/dump profession_id("Leatherworking")


--/dump LibStub("LibProfessions-0"):GetAllSkills()
--/dump LibStub("LibProfessions-0"):GetAllSkills("Secondary Skills")
function lib:GetAllSkills(header_filters)
    if type(header_filters) == 'string' then
        header_filters = {header_filters}
    end

    local skills = {}
    local header_name = ''
    local i = 1
    -- BfA has no skills, only professions
    if not WoWClassic then
        return
    else
        local numSkills = _G.GetNumSkillLines();
        for skillIndex=1,  numSkills, 1 do
            local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank,
                  isAbandonable, stepCost, rankCost, minLevel, skillCostType = _G.GetSkillLineInfo(skillIndex);
            --print(skillName, header, skillRank)
            if ( header ) then
                header_name = skillName
            else
                local skill_info = {skillName, header, isExpanded, skillRank, numTempPoints, skillModifier,
                                    skillMaxRank, isAbandonable, stepCost, rankCost, minLevel, skillCostType,
                                    rank_max[skillMaxRank], header_name}

                if header_filters ~=nil then
                    for _, header_filter in ipairs(header_filters) do
                        if header_filter == header_name then
                            skills[skillName] = skill_info
                            i = i + 1
                        end
                    end
                else
                    skills[skillName] = skill_info
                end
            end
        end
    end
    return skills
end


--/dump LibStub("LibProfessions-0"):GetSkill("Leatherworking")
--/dump LibStub("LibProfessions-0"):GetSkill("Cooking")
function lib:GetSkill(profession_name)
    local skills = self:GetProfessions(true)
    return skills[profession_name]
end


--/dump LibStub("LibProfessions-0"):GetProfessions()
--/dump LibStub("LibProfessions-0"):GetProfessions(true)
function lib:GetProfessions(include_secondary)
    if include_secondary == nil then
        include_secondary = false
    end

    local skills = {}
    if WoWClassic then
        local profession_skills =  self:GetAllSkills("Professions")
        if include_secondary then
            local secondary_skills =  self:GetAllSkills("Secondary Skills")
            for k,v in pairs(secondary_skills) do profession_skills[k] = v end
        end

        local name
        for _, skill_info in pairs(profession_skills) do
            name = skill_info[1]
            skills[name] = {name = name, skill = skill_info[4], max_skill = skill_info[7], modifier = skill_info[5]}
        end
    else
        local prof1, prof2, arch, fish, cook = _G.GetProfessions();
        for _, index in ipairs({prof1, prof2, arch, fish, cook}) do
            local name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier, specializationIndex,
            specializationOffset, skillLineName = _G.GetProfessionInfo(index);
            skills[name] = {name = name, skill = rank, max_skill = maxRank,
                            modifier = rankModifier, specialization = skillLineName}
        end
    end
    return skills
end

function lib:GetProfessionInfo(index)
    local profs = self:GetProfessions()
    local skillName, header, isExpanded, skillRank, numTempPoints, skillModifier, skillMaxRank, isAbandonable,
    stepCost, rankCost, minLevel, skillCostType, rank_name, header_name = profs[index]
    local icon = self:icon(skillName)
    local numAbilities = 0 --TODO: Set this to correct value
    return skillName, icon, skillRank, skillMaxRank, numAbilities, nil, nil, skillModifier, nil, nil, rank_name
end
function _G.GetTradeSkillLine()
    local skillLineName = 'Alchemy'
    local skillLineRank = 10
    local skillLineMaxRank = 125

    return skillLineName, skillLineRank, skillLineMaxRank
end

function _G.GetNumTradeSkills()
    return 2
end

function _G.GetTradeSkillNumReagents(recipeID)
    if recipeID == 3447 then
        return 3
    end
end

function _G.GetTradeSkillReagentItemLink(skillId, reagentId)
    if skillId == 3447 and reagentId == 1 then
        return '\124cffffffff\124Hitem:2453::::::::60:::::\124h[Bruiseweed]\124h\124r'
    end
end

function _G.GetTradeSkillReagentInfo(tradeSkillRecipeId, reagentId)
    if tradeSkillRecipeId == 3447 and reagentId == 1 then
        local reagentName = 'Bruiseweed'
        local reagentTexture = 'inv_misc_herb_01'
        local reagentCount = 1
        local playerReagentCount = 20

        return reagentName, reagentTexture, reagentCount, playerReagentCount
    end
end
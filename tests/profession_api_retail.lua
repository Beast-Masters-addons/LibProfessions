_G.C_TradeSkillUI = {}

function _G.C_TradeSkillUI.IsTradeSkillReady()
    return true
end

function _G.C_TradeSkillUI.IsDataSourceChanging()
    return false
end

function _G.C_TradeSkillUI.GetTradeSkillLine()
    local skillLineName = 'Alchemy'
    local skillLineRank = 10
    local skillLineMaxRank = 125

    return skillLineName, skillLineRank, skillLineMaxRank
end

function _G.C_TradeSkillUI.GetRecipeNumReagents(recipeID)
    if recipeID == 3447 then
        return 3
    end
end

function _G.C_TradeSkillUI.GetRecipeReagentItemLink(skillId, reagentId)
    if skillId == 3447 and reagentId == 1 then
        return '\124cffffffff\124Hitem:2453::::::::60:::::\124h[Bruiseweed]\124h\124r'
    end
end

function _G.C_TradeSkillUI.GetRecipeReagentInfo(tradeSkillRecipeId, reagentId)
    if tradeSkillRecipeId == 3447 and reagentId == 1 then
        local reagentName = 'Bruiseweed'
        local reagentTexture = 'inv_misc_herb_01'
        local reagentCount = 1
        local playerReagentCount = 20

        return reagentName, reagentTexture, reagentCount, playerReagentCount
    end
end
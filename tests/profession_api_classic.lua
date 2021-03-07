function _G.GetTradeSkillLine()
    local skillLineName = 'Alchemy'
    local skillLineRank = 10
    local skillLineMaxRank = 125

    return skillLineName, skillLineRank, skillLineMaxRank
end

function _G.GetNumTradeSkills()
    return 1
end

function _G.GetTradeSkillInfo(recipeID)
    if recipeID == 2 or 3447 then
        return 'Healing Potion', 'optimal', 10
    end
end

function _G.GetTradeSkillItemLink(recipeID)
    if recipeID == 2 or 3447 then
        return '\124cffffffff\124Hitem:929::::::::60:::::\124h[Healing Potion]\124h\124r'
    else
        error('Invalid recipeID ' .. recipeID)
    end
end

function _G.GetTradeSkillNumReagents(recipeID)
    if recipeID == 2 or 3447 then
        return 3
    else
        error('Invalid recipeID ' .. recipeID)
    end
end

function _G.GetTradeSkillReagentItemLink(skillId, reagentId)
    if skillId == 2 or 3447 then
        if reagentId == 1 then
            return '\124cffffffff\124Hitem:2453::::::::60:::::\124h[Bruiseweed]\124h\124r'
        elseif reagentId == 2 then
            return '\124cffffffff\124Hitem:2450::::::::60:::::\124h[Briarthorn]\124h\124r'
        elseif reagentId == 3 then
            return '\124cffffffff\124Hitem:3372::::::::60:::::\124h[Leaded Vial]\124h\124r;'
        end
    else
        error('Invalid skillId ' .. skillId)
    end
end

function _G.GetTradeSkillReagentInfo(tradeSkillRecipeId, reagentId)
    if tradeSkillRecipeId == 2 or 3447 then
        if reagentId == 1 then
            return 'Bruiseweed', 'inv_misc_herb_01', 1, 20
        elseif reagentId == 2 then
            return 'Briarthorn', 'inv_misc_root_01', 1, 16
        elseif reagentId == 3 then
            return 'Leaded Vial', 'inv_drink_06', 1, 20
        end
    end
end
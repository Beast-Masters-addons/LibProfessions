local profession = LibStub:NewLibrary("CurrentProfessions-1.0", 1)
--local CurrentProfession = LibStub("CurrentProfessions-1.0")

function profession:IdFromLink(link)
    local _, _, id = string.find(link, "item:(%d+)");
    return tonumber(id);
end

--local tradeSkillID, skillLineName, skillLineRank, skillLineMaxRank, skillLineModifier = CurrentProfession:GetInfo()
function profession:GetInfo()
    return GetTradeSkillLine();
end

function profession:ProfessionIs(profession_id)
    local tradeSkillID = self:GetInfo()
    if tradeSkillID ~= profession_id then
        return false
    else
        return true
    end
end

function profession:NumRecipes()
   return GetNumTradeSkills()
end

function profession:GetReagents(recipeID)
    local reagents = {}
    local numReagents = GetTradeSkillNumReagents(recipeID);
    if numReagents > 0 then
        for reagent_Index = 1, numReagents, 1 do
            local reagentLink = GetTradeSkillReagentItemLink(recipeID, reagent_Index);
            local reagentName, reagentTexture, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(recipeID, reagent_Index);
            if reagentLink then
                local reagentItemID = self:IdFromLink(reagentLink)
                reagents[reagent_Index] = {reagentItemID, reagentName, reagentTexture, reagentCount, playerReagentCount, reagentLink}
            end
        end
        return reagents
    end
end

function profession:GetRecipes()
    local recipes = {}
    for recipeID = 1, self:NumRecipes(), 1 do

        local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(recipeID);
        if skillType == "header" or skillType == nil then -- skip header by increasing recipeID
            recipeID = recipeID +1
            skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(recipeID);
        end

        recipes[recipeID] = {skillName, skillType, numAvailable, isExpanded}
        recipes[recipeID]['name'] = skillName
        recipes[recipeID]['difficulty'] = skillType
        recipes[recipeID]['available'] = numAvailable
    end
    return recipes
end

function profession:DifficultyToNum(difficulty)
    local difficulties = {
        ["optimal"]	= 4,
        ["orange"]	= 4,
        ["medium"]	= 3,
        ["yellow"]	= 3,
        ["easy"]	= 2,
        ["green"]	= 2,
        ["trivial"]	= 1,
        ["gray"]	= 1,
        ["grey"]	= 1,
    }
    return difficulties[difficulty]
end
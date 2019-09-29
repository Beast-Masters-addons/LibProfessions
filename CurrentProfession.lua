function profession:IdFromLink(link)
    local _, _, id = string.find(link, "item:(%d+)");
    return tonumber(id);
end

function profession:ProfessionIs(profession_id)
    local tradeSkillID = self:GetInfo()
    if tradeSkillID ~= profession_id then
        return false
    else
        return true
    end
end

--/dump LibStub("CurrentProfessions-1.0"):GetReagents(2)
--/dump LibStub("CurrentProfessions-1.0"):GetReagents(160962)
function profession:GetReagents(recipeID)
    local reagents = {}
    local numReagents = self:NumReagents(recipeID);
    if numReagents > 0 then
        for reagent_Index = 1, numReagents, 1 do
            local reagentLink = self:GetReagentItemLink(recipeID, reagent_Index);
            local reagentName, reagentTexture, reagentCount, playerReagentCount = self:GetReagentInfo(recipeID, reagent_Index);
            if reagentLink then
                local reagentItemID = self:IdFromLink(reagentLink)
                reagents[reagent_Index] = {["reagentItemID"]=reagentItemID, ["reagentName"]=reagentName,
                                           ["reagentTexture"]=reagentTexture, ["reagentCount"]=reagentCount,
                                           ["playerReagentCount"]=playerReagentCount, ["reagentLink"]=reagentLink}
            end
        end
        return reagents
    end
end

--/dump LibStub("CurrentProfessions-1.0"):GetRecipes()
function profession:GetRecipes()
    local recipes = {}
    if WoWClassic then
        --@debug@
        print(string.format('Found %d recipes for %s', self:NumRecipes(), self:GetInfo()))
        --@end-debug@
        for recipeID = 1, self:NumRecipes(), 1 do

            local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(recipeID);
            if skillType == "header" or skillType == nil then -- skip header by increasing recipeID
                recipeID = recipeID +1
                skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(recipeID);
            end

            recipes[recipeID] = {}
            recipes[recipeID]['name'] = skillName
            recipes[recipeID]['difficulty'] = skillType
            recipes[recipeID]['numAvailable'] = numAvailable
            recipes[recipeID]['link'] = GetTradeSkillItemLink(recipeID)
        end
    else
        for _, recipeID in pairs(C_TradeSkillUI.GetAllRecipeIDs()) do
            recipes[recipeID] = {}
            recipes[recipeID] = C_TradeSkillUI.GetRecipeInfo(recipeID)
        end
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
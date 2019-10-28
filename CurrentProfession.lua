function profession:IdFromLink(link)
    local _, _, id = string.find(link, "item:(%d+)");
    return tonumber(id);
end

--/dump LibStub("LibProfessions-1.0"):ProfessionIs("Cooking")
function profession:ProfessionIs(profession_name)
    local current_name = self:GetName()
    if current_name ~= profession_name then
        return false
    else
        return true
    end
end

--/dump LibStub("LibProfessions-1.0"):GetReagents(2)
--/dump LibStub("LibProfessions-1.0"):GetReagents(160962)
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

--/dump LibStub("LibProfessions-1.0"):GetRecipes()
function profession:GetRecipes()
    local recipes = {}
    if WoWClassic then
        --@debug@
        print(string.format('Found %d recipes for %s', self:NumRecipes(), self:GetInfo()))
        --@end-debug@
        --In Classic the recipeID indicates the place of the recipe in the list
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
        --In BfA the recipeID is a real ID
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

function profession:DifficultyColor(difficulty)
    local TradeSkillTypeColor = {}
    TradeSkillTypeColor["optimal"]	= { r = 1.00, g = 0.50, b = 0.25, font = "GameFontNormalLeftOrange" };
    TradeSkillTypeColor["medium"]	= { r = 1.00, g = 1.00, b = 0.00, font = "GameFontNormalLeftYellow" };
    TradeSkillTypeColor["easy"]		= { r = 0.25, g = 0.75, b = 0.25, font = "GameFontNormalLeftLightGreen" };
    TradeSkillTypeColor["trivial"]	= { r = 0.50, g = 0.50, b = 0.50, font = "GameFontNormalLeftGrey" };
    TradeSkillTypeColor["header"]	= { r = 1.00, g = 0.82, b = 0,    font = "GameFontNormalLeft" };

    return TradeSkillTypeColor[difficulty]
end
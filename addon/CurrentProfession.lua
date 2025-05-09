---@type LibProfessions
local addon = _G['LibProfessions-@project-version@']
if not addon then
    -- luacov: disable
    return    -- already loaded and no upgrade necessary
    -- luacov: enable
end
---@class LibProfessionsCurrentProfession A library to get information about the current profession
local profession = addon.currentProfession
local api = addon.api
---@type BMUtils
local utils = _G.LibStub('BM-utils-2'):GetModule('BMUtils')

--/dump LibStub("LibCurrentProfession-1.0"):ProfessionIs("Cooking")
function profession:ProfessionIs(profession_name)
    local current_name = api:GetInfo()
    if current_name ~= profession_name then
        return false
    else
        return true
    end
end

--/dump LibStub("LibCurrentProfession-1.0"):GetReagents(2)
--/dump LibStub("LibCurrentProfession-1.0"):GetReagents(160962)
function profession:GetReagents(recipeID)
    local reagents = {}
    if addon.is_classic then
        local numReagents = api:NumReagents(recipeID);
        if numReagents > 0 then
            for reagent_Index = 1, numReagents, 1 do
                local reagentLink = api:GetReagentItemLink(recipeID, reagent_Index);
                local reagentName, reagentTexture, reagentCount, playerReagentCount =
                api:GetReagentInfo(recipeID, reagent_Index);
                if reagentLink then
                    local reagentItemID = utils.itemIdFromLink(reagentLink)
                    reagents[reagent_Index] = { ["reagentItemID"] = reagentItemID,
                                                ["reagentName"] = reagentName,
                                                ["reagentTexture"] = reagentTexture,
                                                ["reagentCount"] = reagentCount,
                                                ["playerReagentCount"] = playerReagentCount,
                                                ["reagentLink"] = reagentLink }
                end
            end
            return reagents
        end
    else
        local schematic = _G.C_TradeSkillUI.GetRecipeSchematic(recipeID, false)
        for index, slot in ipairs(schematic['reagentSlotSchematics']) do
            for _, reagent in ipairs(slot['reagents']) do
                local reagentLink = api:GetReagentItemLink(recipeID, index)
                if reagentLink then
                    local itemID = utils.itemIdFromLink(reagentLink)
                    local reagentName = utils.itemNameFromLink(reagentLink)

                    reagents[index] = {
                        ["reagentItemID"] = itemID,
                        ["reagentName"] = reagentName,
                        --["reagentTexture"]=reagentTexture,
                        ["reagentCount"] = slot['quantityRequired'],
                        --["playerReagentCount"]=playerReagentCount,
                        ["reagentLink"] = reagentLink }
                end
                --@debug@
                print(('Recipe %d need %d %s (item id %d)'):format(recipeID, slot['quantityRequired'],
                        reagentLink, reagent['itemID']))
                --@end-debug@
            end
        end
        return reagents
    end
end

--/dump LibStub("LibCurrentProfession-1.0"):GetRecipes()
function profession:GetRecipes()
    local recipes = {}
    if addon.is_classic then
        --@debug@
        print(string.format('Found %d recipes for %s', api:NumRecipes(), api:GetInfo()))
        --@end-debug@
        --In Classic the recipeID indicates the place of the recipe in the list
        for recipeID = 1, api:NumRecipes(), 1 do
            local skillName, skillType, numAvailable = _G.GetTradeSkillInfo(recipeID);
            if skillType == "header" or skillType == nil then -- skip header by increasing recipeID
                recipeID = recipeID +1
                skillName, skillType, numAvailable = _G.GetTradeSkillInfo(recipeID);
            end

            recipes[recipeID] = {}
            recipes[recipeID]['name'] = skillName
            recipes[recipeID]['difficulty'] = skillType
            recipes[recipeID]['numAvailable'] = numAvailable
            recipes[recipeID]['link'] = _G.GetTradeSkillItemLink(recipeID)
            recipes[recipeID]['recipeLink'] = _G.GetTradeSkillRecipeLink(recipeID)
            if recipes[recipeID]['recipeLink'] then
                recipes[recipeID]['recipeId'] = tonumber(string.match(recipes[recipeID]['recipeLink'], "enchant:(%d+)"))
            else
                recipes[recipeID]['recipeId'] = nil
            end
        end
    else
        --In BfA the recipeID is a real ID
        for _, recipeID in pairs(_G.C_TradeSkillUI.GetAllRecipeIDs()) do
            recipes[recipeID] = {}
            recipes[recipeID] = _G.C_TradeSkillUI.GetRecipeInfo(recipeID)
            recipes[recipeID]['link'] = _G.C_TradeSkillUI.GetRecipeItemLink(recipeID)
            recipes[recipeID]['recipeLink'] = _G.C_TradeSkillUI.GetRecipeItemLink(recipeID)
            recipes[recipeID]['recipeId'] = tonumber(string.match(recipes[recipeID]['recipeLink'], "enchant:(%d+)"))
        end
    end
    return recipes
end

---A library to make similar profession API calls for classic and BfA
-- luacheck: ignore api
_G['ProfessionAPI'] = {}
local api = _G['ProfessionAPI']
api = LibStub:NewLibrary("LibProfessionAPI-1.0", 1)
if not api then
    return	-- already loaded and no upgrade necessary
end

-- defined in LibProfessions.lua
local WoWClassic = _G['WoWClassic']

--local WoWClassic = select(4, GetBuildInfo()) < 20000

function api:IsReady()
    if WoWClassic then --Professions are always ready in classic
        return true
    elseif not C_TradeSkillUI.IsTradeSkillReady() or C_TradeSkillUI.IsDataSourceChanging() then
        return false
    else
        return true
    end
end

--local tradeSkillID, skillLineName, skillLineRank, skillLineMaxRank, skillLineModifier = compat:GetInfo()
function api:GetInfo()
    if WoWClassic then
        return GetTradeSkillLine();
    else
        return C_TradeSkillUI.GetTradeSkillLine()
    end
end

--/dump LibStub("LibProfessions-1.0"):GetName()
function api:GetName()
    local name
    if WoWClassic then
        name = GetTradeSkillLine()
    else
        _, _, _, _, _, _, name = C_TradeSkillUI.GetTradeSkillLine()
    end
    return name
end

function api:NumRecipes()
    return GetNumTradeSkills()
end

function api:NumReagents(recipeID)
    if WoWClassic then
        return GetTradeSkillNumReagents(recipeID)
    else
        return C_TradeSkillUI.GetRecipeNumReagents(recipeID)
    end
end

function api:GetReagentItemLink(recipeID, reagentIndex)
    if WoWClassic then
        return GetTradeSkillReagentItemLink(recipeID, reagentIndex);
    else
        return C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex);
    end
end

function api:GetReagentInfo(recipeID, reagentIndex)
    if WoWClassic then
        return GetTradeSkillReagentInfo(recipeID, reagentIndex);
    else
        return C_TradeSkillUI.GetRecipeReagentInfo(recipeID, reagentIndex)
    end
end
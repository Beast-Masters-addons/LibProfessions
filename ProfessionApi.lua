--A library to make similar profession API calls for classic and BfA
--local profession = LibStub:NewLibrary("LibProfession-1.0", 1)

-- defined in LibProfessions.lua
local profession = profession
local WoWClassic = WoWClassic

--local WoWClassic = select(4, GetBuildInfo()) < 20000

function profession:IsReady()
    if WoWClassic then --Professions are always ready in classic
        return true
    elseif not C_TradeSkillUI.IsTradeSkillReady() or C_TradeSkillUI.IsDataSourceChanging() then
        return false
    else
        return true
    end
end

--local tradeSkillID, skillLineName, skillLineRank, skillLineMaxRank, skillLineModifier = compat:GetInfo()
function profession:GetInfo()
    if WoWClassic then
        return GetTradeSkillLine();
    else
        return C_TradeSkillUI.GetTradeSkillLine()
    end
end

--/dump LibStub("LibProfessions-1.0"):GetName()
function profession:GetName()
    local name
    if WoWClassic then
        name = GetTradeSkillLine()
    else
        _, _, _, _, _, _, name = C_TradeSkillUI.GetTradeSkillLine()
    end
    return name
end

function profession:NumRecipes()
    return GetNumTradeSkills()
end

function profession:NumReagents(recipeID)
    if WoWClassic then
        return GetTradeSkillNumReagents(recipeID)
    else
        return C_TradeSkillUI.GetRecipeNumReagents(recipeID)
    end
end

function profession:GetReagentItemLink(recipeID, reagentIndex)
    if WoWClassic then
        return GetTradeSkillReagentItemLink(recipeID, reagentIndex);
    else
        return C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex);
    end
end

function profession:GetReagentInfo(recipeID, reagentIndex)
    if WoWClassic then
        return GetTradeSkillReagentInfo(recipeID, reagentIndex);
    else
        return C_TradeSkillUI.GetRecipeReagentInfo(recipeID, reagentIndex)
    end
end
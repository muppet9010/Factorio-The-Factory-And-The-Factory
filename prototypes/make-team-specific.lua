local Constants = require("constants")


local entityTypesAffectedByLandOwnership = {["accumulator"] = true, ["artillery-turret"] = true, ["beacon"] = true , ["boiler"] = true, ["arithmetic-combinator"] = true, ["decider-combinator"] = true, ["constant-combinator"] = true, ["container"] = true, ["logistic-container"] = true, ["infinity-container"] = true, ["assembling-machine"] = true, ["rocket-silo"] = true, ["furnace"] = true, ["electric-pole"] = true, ["gate"] = true, ["generator"] = true, ["heat-pipe"] = true, ["inserter"] = true, ["lab"] = true, ["lamp"] = true,["mining-drill"] = true, ["offshore-pump"] = true, ["pipe"] = true, ["pipe-to-ground"] = true, ["power-switch"] = true, ["programmable-speaker"] = true, ["pump"] = true, ["radar"] = true, ["curved-rail"] = true, ["straight-rail"] = true, ["rail-chain-signal"] = true, ["rail-signal"] = true, ["reactor"] = true, ["roboport"] = true, ["solar-panel"] = true, ["storage-tank"] = true, ["train-stop"] = true, ["loader"] = true, ["splitter"] = true, ["transport-belt"] = true, ["underground-belt"] = true, ["turret"] = true, ["ammo-turret"] = true, ["electric-turret"] = true, ["fluid-turret"] = true, ["wall"] = true}
local entityTypesNotOnOpponentLandOwnership = {["land-mine"] = true}
local entityNamesAffectedByLandOwnership = {} -- { {ENTITYNAME = true} }
local itemNamesAffectedByLandOwnership = {} -- { {ITEMNAME = true} }
local recipeNamesAffectedByLandOwnership = {} -- { {RECIPENAME = true} }


local generatedLandOwnershipEntityNames = {}
local function GenerateLandOwnershipSpecificGameEntities(team)
    for type, prototypes in pairs(data.raw) do
        if entityTypesAffectedByLandOwnership[type] then
            for _, prototype in pairs(prototypes) do
                if not generatedLandOwnershipEntityNames[prototype.name] then
                    local landOwnedSpecificEntity = table.deepcopy(prototype)
                    landOwnedSpecificEntity.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.name)
                    if landOwnedSpecificEntity.collision_mask ~= nil then
                        for _, mask in pairs(Constants.BuildingCollisionMaskLists[team.name]) do
                            table.insert(landOwnedSpecificEntity.collision_mask, mask)
                        end
                    else
                        landOwnedSpecificEntity.collision_mask = Constants.BuildingCollisionMaskLists[team.name]
                    end
                    if landOwnedSpecificEntity.minable ~= nil then
                        landOwnedSpecificEntity.minable.result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.minable.result)
                    end
                    landOwnedSpecificEntity.localised_name = {"entity-name." .. prototype.name}
                    landOwnedSpecificEntity.localised_description = {"entity-description." .. prototype.name}
                    data:extend({landOwnedSpecificEntity})
                    entityNamesAffectedByLandOwnership[prototype.name] = true
                    generatedLandOwnershipEntityNames[landOwnedSpecificEntity.name] = true
                end
            end
        elseif entityTypesNotOnOpponentLandOwnership[type] then
            for _, prototype in pairs(prototypes) do
                if not generatedLandOwnershipEntityNames[prototype.name] then
                    local landOwnedSpecificEntity = table.deepcopy(prototype)
                    landOwnedSpecificEntity.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.name)
                    if landOwnedSpecificEntity.collision_mask == nil then
                        landOwnedSpecificEntity.collision_mask = {}
                    end
                    for _, mask in pairs(Constants.BuildingCollisionMaskLists[team.name]) do
                        if mask ~= Constants.CollisionMasks.none then
                            table.insert(landOwnedSpecificEntity.collision_mask, mask)
                        end
                    end
                    if landOwnedSpecificEntity.minable ~= nil then
                        landOwnedSpecificEntity.minable.result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.minable.result)
                    end
                    landOwnedSpecificEntity.localised_name = {"entity-name." .. prototype.name}
                    landOwnedSpecificEntity.localised_description = {"entity-description." .. prototype.name}
                    data:extend({landOwnedSpecificEntity})
                    entityNamesAffectedByLandOwnership[prototype.name] = true
                    generatedLandOwnershipEntityNames[landOwnedSpecificEntity.name] = true
                end
            end
        end
    end
end


local generatedLandOwnershipItemNames = {}
local function GenerateLandOwnershipSpecificGameItem(item, team)
    if entityNamesAffectedByLandOwnership[item.place_result] and not generatedLandOwnershipItemNames[item.name] then
        local landOwnedSpecificItem = table.deepcopy(item)
        landOwnedSpecificItem.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificItem.name)
        landOwnedSpecificItem.place_result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificItem.place_result)
        landOwnedSpecificItem.localised_name = {"entity-name." .. item.name}
        landOwnedSpecificItem.localised_description = {"entity-description." .. item.name}
        data:extend({landOwnedSpecificItem})
        itemNamesAffectedByLandOwnership[item.name] = true
        generatedLandOwnershipItemNames[landOwnedSpecificItem.name] = true
    end
end
local function GenerateLandOwnershipSpecificGameItems(team)
    for _, item in pairs(data.raw["item"]) do
        GenerateLandOwnershipSpecificGameItem(item, team)
    end
    for _, item in pairs(data.raw["rail-planner"]) do
        GenerateLandOwnershipSpecificGameItem(item, team)
    end
end


--I don't believe any of our affected entities are ever returned in a multiple result (results) recipe so not coded for.
local generatedLandOwnershipRecipeNames = {}
local function GenerateLandOwnershipSpecificGameRecipes(team)
    for _, recipe in pairs(data.raw["recipe"]) do
        if itemNamesAffectedByLandOwnership[recipe.result] and not generatedLandOwnershipRecipeNames[recipe.name] then
            local landOwnedSpecificRecipe = table.deepcopy(recipe)
            landOwnedSpecificRecipe.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificRecipe.name)
            if landOwnedSpecificRecipe.result ~= nil then
                landOwnedSpecificRecipe.result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificRecipe.result)
            end
            if landOwnedSpecificRecipe.normal ~= nil and landOwnedSpecificRecipe.normal.result ~= nil then
                landOwnedSpecificRecipe.normal.result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificRecipe.normal.result)
            end
            if landOwnedSpecificRecipe.expensive ~= nil and landOwnedSpecificRecipe.expensive.result ~= nil then
                landOwnedSpecificRecipe.expensive.result = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificRecipe.expensive.result)
            end
            landOwnedSpecificRecipe.enabled = false
            data:extend({landOwnedSpecificRecipe})
            recipeNamesAffectedByLandOwnership[recipe.name] = true
            generatedLandOwnershipRecipeNames[landOwnedSpecificRecipe.name] = true
        end
    end
end



for _, team in pairs(Constants.Teams) do
    if team.playerConstruction then
        GenerateLandOwnershipSpecificGameEntities(team)
        GenerateLandOwnershipSpecificGameItems(team)
        GenerateLandOwnershipSpecificGameRecipes(team)
    end
end

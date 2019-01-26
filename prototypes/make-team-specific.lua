local Constants = require("constants")


local entityNamesAffectedByLandOwnership = {} -- { {ENTITYNAME = true} }
local itemNamesAffectedByLandOwnership = {} -- { {ITEMNAME = true} }


local generatedLandOwnershipEntityNames = {}
local function GenerateLandOwnershipSpecificGameEntities(team)
    for type, prototypes in pairs(data.raw) do
        if Constants.EntityTypesAffectedByLandOwnership[type] then
            for _, prototype in pairs(prototypes) do
                if not generatedLandOwnershipEntityNames[prototype.name] then
                    local landOwnedSpecificEntity = table.deepcopy(prototype)
                    landOwnedSpecificEntity.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.name)
                    if landOwnedSpecificEntity.collision_mask == nil then
                        landOwnedSpecificEntity.collision_mask = {"item-layer", "object-layer", "player-layer", "water-tile"} --have to set a default for those that have nothing set in lua but inherit a default in game code if nil
                    end
                    for _, mask in pairs(team.buildingCollisionMaskList) do
                        table.insert(landOwnedSpecificEntity.collision_mask, mask)
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
        elseif Constants.EntityTypesNotOnOpponentLandOwnership[type] then
            for _, prototype in pairs(prototypes) do
                if not generatedLandOwnershipEntityNames[prototype.name] then
                    local landOwnedSpecificEntity = table.deepcopy(prototype)
                    landOwnedSpecificEntity.name = Constants.MakeTeamSpecificThingName(team, landOwnedSpecificEntity.name)
                    if landOwnedSpecificEntity.collision_mask == nil then
                        landOwnedSpecificEntity.collision_mask = {}
                    end
                    for _, mask in pairs(team.buildingCollisionMaskList) do
                        table.insert(landOwnedSpecificEntity.collision_mask, mask)
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

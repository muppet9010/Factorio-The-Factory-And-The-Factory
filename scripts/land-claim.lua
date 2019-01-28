local Constants = require("constants")
local Events = require("factorio-utils/events")
local Utils = require("factorio-utils/utils")
local Logging = require("factorio-utils/logging")
local LandClaim = {}


function LandClaim.RegisterEvents()
    Events.RegisterHandler(defines.events.on_player_selected_area, "LandClaim.OnSelectedAreaWithLandClaimTool", LandClaim.OnSelectedAreaWithLandClaimTool)
    Events.RegisterHandler(defines.events.on_player_alt_selected_area, "LandClaim.OnAltSelectedAreaWithLandClaimTool", LandClaim.OnAltSelectedAreaWithLandClaimTool)
    Events.RegisterHandler(defines.events.on_built_entity, "LandClaim.BuildingPlacedPlayerCheckLandClaim", LandClaim.BuildingPlacedPlayerCheckLandClaim)
    Events.RegisterHandler(defines.events.on_robot_built_entity, "LandClaim.BuildingPlacedRobotCheckLandClaim", LandClaim.BuildingPlacedRobotCheckLandClaim)
end


function LandClaim.OnStartup()
    LandClaim.CalculateMaxPoweredSearchRadius()
    LandClaim.OnLoad()
end


function LandClaim.OnLoad()
    LandClaim.RegisterEvents()
end


function LandClaim.OnSelectedAreaWithLandClaimTool(eventData)
    local player = game.players[eventData.player_index]
    local team = Constants.Teams[player.force.name]
    if team == nil then return end
    local landClaim = team.landClaim
    local landClaimName = landClaim.name
    local itemUsedName = eventData.item
    if itemUsedName ~= landClaimName then return end

    local tilesSelected = eventData.tiles
    local landClaimTilesHeld = player.get_item_count(landClaimName)
    local landClaimTilePositionsRequired = {}
    local surface = player.surface

    for _, tile in pairs(tilesSelected) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tile.position, {x=0.5, y=0.5})
        if surface.can_place_entity{name=landClaimName, position=tileEntityPosition, force=player.force} then
            local tileAtPosition = surface.get_tile(tileEntityPosition.x, tileEntityPosition.y)
            if not tileAtPosition.collides_with("water-tile") then
                local entitiesFound = surface.find_entities_filtered{area = Utils.CalculateBoundingBoxFromPositionAndRange(tileEntityPosition, 0.1), name = Constants.AllLandClaimNamesList}
                local blocked = false
                for _, entityFound in pairs(entitiesFound) do
                    if entityFound.name == landClaimName then
                        blocked = true
                        break
                    elseif Constants.LandClaims[entityFound.name] ~= nil then
                        blocked = true
                        break
                    end
                end
                if not blocked then
                    table.insert(landClaimTilePositionsRequired, tileEntityPosition)
                end
            end
        end
    end


    if #landClaimTilePositionsRequired == 0 then return end

    if #landClaimTilePositionsRequired > landClaimTilesHeld then
        surface.create_entity{name = "flying-text", position = tilesSelected[#tilesSelected].position, text = {"player-message.not-enough-land-claim-tiles"}, color = Constants.Color.Red}
        return
    end

    for _, requiredPosition in pairs(landClaimTilePositionsRequired) do
        surface.create_entity{name = landClaimName, position = requiredPosition, force = player.force}
    end
    player.remove_item({name = landClaimName, count = #landClaimTilePositionsRequired})
end


function LandClaim.OnAltSelectedAreaWithLandClaimTool(eventData)
    local player = game.players[eventData.player_index]
    local landClaim = Constants.Teams[player.force.name].landClaim
    local landClaimName = landClaim.name
    local itemUsedName = eventData.item
    if itemUsedName ~= landClaimName then return end

    local tilesSelected = eventData.tiles
    local surface = player.surface
    local tilesRemoved = 0
    for _, tile in pairs(tilesSelected) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tile.position, {x=0.5, y=0.5})
        local entitiesFound = surface.find_entities_filtered{area = Utils.CalculateBoundingBoxFromPositionAndRange(tileEntityPosition, 0.1), force = player.force}
        local landClaimToRemove
        local buildingBlocksRemoval = false
        for _, entityFound in pairs(entitiesFound) do
            if entityFound.name == landClaimName then
                landClaimToRemove = entityFound
            elseif Constants.EntityTypesAffectedByLandOwnership[entityFound.type] ~= nil then
                buildingBlocksRemoval = true
                break
            end
        end
        if landClaimToRemove ~= nil and not buildingBlocksRemoval then
            landClaimToRemove.destroy()
            tilesRemoved = tilesRemoved + 1
        end
    end
    if tilesRemoved > 0 then
        player.insert({name = landClaimName, count = tilesRemoved})
    end
end


function LandClaim.BuildingPlacedPlayerCheckLandClaim(eventData)
    local createdEntity = eventData.created_entity
    if not createdEntity.valid then return end
    if Constants.EntityTypesAffectedByLandOwnership[createdEntity.type] == nil then return end

    local player = game.players[eventData.player_index]
    local surface = player.surface
    local landClaim = Constants.Teams[player.force.name].landClaim
    local landClaimName = landClaim.name
    local landClaimNeeded, landClaimTeamCollision = LandClaim.CheckLandClaimNeededForBuilding(createdEntity, player, landClaimName)
    if landClaimTeamCollision then
        surface.create_entity{name = "flying-text", position = createdEntity.position, text = {"player-message.overlaps-other-team-land-claim"}, color = Constants.Color.Red}
        player.insert({name = Utils.GetEntityReturnedToInventoryName(createdEntity), count = 1})
        createdEntity.destroy()
    end
    local landClaimNeededCount = Utils.GetTableLength(landClaimNeeded)
    if landClaimNeededCount == 0 then return end

    local landClaimTilesHeld = player.get_item_count(landClaimName)
    if landClaimNeededCount <= landClaimTilesHeld then
        for _, requiredPosition in pairs(landClaimNeeded) do
            surface.create_entity{name = landClaimName, position = requiredPosition, force = player.force}
        end
        player.remove_item({name = landClaimName, count = landClaimNeededCount})
    else
        surface.create_entity{name = "flying-text", position = createdEntity.position, text = {"player-message.not-enough-land-claim-tiles"}, color = Constants.Color.Red}
        player.insert({name = Utils.GetEntityReturnedToInventoryName(createdEntity), count = 1})
        createdEntity.destroy()
    end
end


function LandClaim.BuildingPlacedRobotCheckLandClaim(eventData)
    local createdEntity = eventData.created_entity
    if not createdEntity.valid then return end
    if Constants.EntityTypesAffectedByLandOwnership[createdEntity.type] == nil then return end

    --TODO: need to do the actual useful code
end


function LandClaim.CheckLandClaimNeededForBuilding(createdEntity, builder, landClaimName)
    local surface = createdEntity.surface

    local landClaimNeeded = {}

    --TODO: this is shifted 1 positive for entities that are on a tile boundary , not centred on a tile
    if createdEntity.type == "electric-pole" and createdEntity.prototype.supply_area_distance > 0 then
        local radius = createdEntity.prototype.supply_area_distance - 0.5
        local normalisedCreatedEntityPosition = Utils.ApplyOffsetToPosition(createdEntity.position, {x=-0.5,y=-0.5})
        local searchArea = Utils.CalculateBoundingBoxFromPositionAndRange(normalisedCreatedEntityPosition, radius)
        local tilesToCheck = Utils.CalculateTilesUnderPositionedBoundingBox(searchArea)
        for _, tilePosition in pairs(tilesToCheck) do
            local tileEntityPosition = Utils.ApplyOffsetToPosition(tilePosition, {x=0.5, y=0.5})
            if surface.can_place_entity{name=landClaimName, position=tileEntityPosition, force=createdEntity.force} then
                local tileAtPosition = surface.get_tile(tileEntityPosition.x, tileEntityPosition.y)
                if not tileAtPosition.collides_with("water-tile") then
                    local entitiesFound = surface.find_entities_filtered{area = Utils.CalculateBoundingBoxFromPositionAndRange(tileEntityPosition, 0.1), name = Constants.AllLandClaimNamesList}
                    local alreadyOwned = false
                    for _, entity in pairs(entitiesFound) do
                        if entity.name == landClaimName then
                            alreadyOwned = true
                            break
                        elseif Constants.LandClaims[entity.name] ~= nil then
                            return {}, true
                        end
                    end
                    if not alreadyOwned then
                        landClaimNeeded[Utils.FormatPositionTableToString(tileEntityPosition)] = tileEntityPosition
                    end
                end
            end
        end
    end

    local searchArea = Utils.ApplyBoundingBoxToPosition(createdEntity.position, createdEntity.prototype.collision_box, createdEntity.direction)
    local tilesToCheck = Utils.CalculateTilesUnderPositionedBoundingBox(searchArea)
    for _, tilePosition in pairs(tilesToCheck) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tilePosition, {x=0.5, y=0.5})
        local landClaimFoundCount = surface.count_entities_filtered{area = Utils.CalculateBoundingBoxFromPositionAndRange(tileEntityPosition, 0.1), force = builder.force, name = landClaimName}
        if landClaimFoundCount == 0 then
            landClaimNeeded[Utils.FormatPositionTableToString(tileEntityPosition)] = tileEntityPosition
        end
    end

    return landClaimNeeded, false
end


function LandClaim.CalculateMaxPoweredSearchRadius()
    local maxPoweredSearchRadius = 0
    for _, entity in pairs(game.entity_prototypes) do
        if entity.type == "electric-pole" then
            if entity.supply_area_distance > maxPoweredSearchRadius then
                maxPoweredSearchRadius = entity.supply_area_distance
            end
        end
    end
    global.MOD.MaxPoweredSearchRadius = maxPoweredSearchRadius
end


return LandClaim

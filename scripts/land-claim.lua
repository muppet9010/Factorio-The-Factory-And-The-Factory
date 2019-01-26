local Constants = require("constants")
local Events = require("factorio-utils/events")
local Utils = require("factorio-utils/utils")
--local Logging = require("factorio-utils/logging")
local LandClaim = {}


function LandClaim.RegisterEvents()
    Events.RegisterHandler(defines.events.on_player_selected_area, "LandClaim.OnSelectedAreaWithLandClaimTool", LandClaim.OnSelectedAreaWithLandClaimTool)
    Events.RegisterHandler(defines.events.on_player_alt_selected_area, "LandClaim.OnAltSelectedAreaWithLandClaimTool", LandClaim.OnAltSelectedAreaWithLandClaimTool)
    Events.RegisterHandler(defines.events.on_built_entity, "LandClaim.BuildingPlacedPlayerCheckLandClaim", LandClaim.BuildingPlacedPlayerCheckLandClaim)
    Events.RegisterHandler(defines.events.on_robot_built_entity, "LandClaim.BuildingPlacedRobotCheckLandClaim", LandClaim.BuildingPlacedRobotCheckLandClaim)
end


function LandClaim.OnStartup()
    LandClaim.OnLoad()
end


function LandClaim.OnLoad()
    LandClaim.RegisterEvents()
end


function LandClaim.OnSelectedAreaWithLandClaimTool(eventData)
    local player = game.players[eventData.player_index]
    local landClaim = Constants.LandClaims[player.force.name]
    local landClaimName = landClaim.landClaimName
    local itemUsedName = eventData.item
    if itemUsedName ~= landClaimName then return end

    local tilesSelected = eventData.tiles
    local landClaimTilesHeld = player.get_item_count(landClaimName)
    local landClaimTilePositionsRequired = {}
    local surface = player.surface
    for _, tile in pairs(tilesSelected) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tile.position, {0.5, 0.5})
        local entitiesFound = surface.find_entities_filtered{position = tileEntityPosition, force = player.force}
        local blocked = false
        for _, entityFound in pairs(entitiesFound) do
            if entityFound.name == landClaimName then
                blocked = true
                break
            elseif Constants.LandClaimNames[entityFound.name] ~= nil then
                blocked = true
                break
            end
        end
        if not blocked then
            table.insert(landClaimTilePositionsRequired, tileEntityPosition)
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
    local landClaim = Constants.LandClaims[player.force.name]
    local landClaimName = landClaim.landClaimName
    local itemUsedName = eventData.item
    if itemUsedName ~= landClaimName then return end

    local tilesSelected = eventData.tiles
    local surface = player.surface
    local tilesRemoved = 0
    for _, tile in pairs(tilesSelected) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tile.position, {0.5, 0.5})
        local entitiesFound = surface.find_entities_filtered{position = tileEntityPosition, force = player.force}
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
    local landClaim = Constants.LandClaims[player.force.name]
    local landClaimName = landClaim.landClaimName
    local landClaimNeeded = LandClaim.CheckLandClaimNeededForBuilding(createdEntity, player, landClaimName)
    if #landClaimNeeded == 0 then return end

    local landClaimTilesHeld = player.get_item_count(landClaimName)
    local surface = player.surface
    if #landClaimNeeded <= landClaimTilesHeld then
        for _, requiredPosition in pairs(landClaimNeeded) do
            surface.create_entity{name = landClaimName, position = requiredPosition, force = player.force}
        end
        player.remove_item({name = landClaimName, count = #landClaimNeeded})
    else
        surface.create_entity{name = "flying-text", position = createdEntity.position, text = {"player-message.not-enough-land-claim-tiles"}, color = Constants.Color.Red}
        player.insert({name = createdEntity.name, count = 1})
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
    local searchArea = Utils.CalculatePositionedBoundingBox(createdEntity.position, createdEntity.prototype.collision_box)
    local tilesToCheck = Utils.CalculateTilesUnderPositionedBoundingBox(searchArea)

    local landClaimNeeded = {}
    for _, tilePosition in pairs(tilesToCheck) do
        local tileEntityPosition = Utils.ApplyOffsetToPosition(tilePosition, {0.5, 0.5})
        local landClaimFoundCount = builder.surface.count_entities_filtered{position = tileEntityPosition, force = builder.force, name = landClaimName}
        if landClaimFoundCount == 0 then
            table.insert(landClaimNeeded, tileEntityPosition)
        end
    end
    return landClaimNeeded
end


return LandClaim

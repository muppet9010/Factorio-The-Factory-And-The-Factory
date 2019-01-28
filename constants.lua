local Utils = require("factorio-utils/utils")
local Constants = {}

Constants.ModName = "the_factory_and_the_factory"
Constants.AssetModName = "__" .. Constants.ModName .. "__"

Constants.Color = {
    Invisible = {a=0},
    Green = {r=0, g=0.8, b=0},
    Red = {r=0.9, g=0, b=0},
    White = {r=1, g=1, b=1},
    Black = {r=0, g=0, b=0},
    BrightBlue = {r= 102, g = 217, b = 255},
    DullOrange = {r= 255, g = 153, b = 51}
}

Constants.Teams = {
    team1 = {
        name = "team1",
        playerConstruction = true,
        displayName = "Beszel",
        color = Constants.Color.BrightBlue,
        collisionMaskLayer = "layer-14",
        landClaim = nil, --populated automatically
        buildingCollisionMaskList = nil --populated automatically
    },
    team2 = {
        name = "team2",
        playerConstruction = true,
        displayName = "UI Qoma",
        color = Constants.Color.DullOrange,
        collisionMaskLayer = "layer-15",
        landClaim = nil, --populated automatically
        buildingCollisionMaskList = nil --populated automatically
    },
    breach = {
        name = "breach",
        playerConstruction = false,
        displayName = "Breach"
    },
    player = {
        name = "player",
        playerConstruction = false,
        displayName = "Spectator"
    }
}

Constants.LandClaims = {}
local function MakeLandClaimEntry(teamName)
    local landClaimName = teamName .. "-land-claim"
    Constants.LandClaims[landClaimName] = {
        name = landClaimName,
        entityImageName = "team",
        color = Constants.Teams[teamName].color,
        team = Constants.Teams[teamName],
        collisionMaskList = {Constants.Teams[teamName].collisionMaskLayer}
    }
    Constants.Teams[teamName].landClaim = Constants.LandClaims[landClaimName]
end
MakeLandClaimEntry("team1")
MakeLandClaimEntry("team2")
Constants.AllLandClaimNamesList = Utils.TableKeyToArray(Constants.LandClaims)

--Generate the team's building blocker collision mask layers
for _, team in pairs(Constants.Teams) do
    if team.playerConstruction then
        local otherTeamCollisionMasks = {}
        for _, otherTeam in pairs(Constants.Teams) do
            if otherTeam.playerConstruction and otherTeam.name ~= team.name then
                table.insert(otherTeamCollisionMasks, otherTeam.collisionMaskLayer)
            end
        end
        team.buildingCollisionMaskList = otherTeamCollisionMasks
    end
end

function Constants.MakeTeamSpecificThingName(team, thingName)
    return thingName .. "-" .. team.name
end

Constants.EntityTypesAffectedByLandOwnership = {["accumulator"] = true, ["artillery-turret"] = true, ["beacon"] = true , ["boiler"] = true, ["arithmetic-combinator"] = true, ["decider-combinator"] = true, ["constant-combinator"] = true, ["container"] = true, ["logistic-container"] = true, ["infinity-container"] = true, ["assembling-machine"] = true, ["rocket-silo"] = true, ["furnace"] = true, ["electric-pole"] = true, ["gate"] = true, ["generator"] = true, ["heat-pipe"] = true, ["inserter"] = true, ["lab"] = true, ["lamp"] = true,["mining-drill"] = true, ["offshore-pump"] = true, ["pipe"] = true, ["pipe-to-ground"] = true, ["power-switch"] = true, ["programmable-speaker"] = true, ["pump"] = true, ["radar"] = true, ["curved-rail"] = true, ["straight-rail"] = true, ["rail-chain-signal"] = true, ["rail-signal"] = true, ["reactor"] = true, ["roboport"] = true, ["solar-panel"] = true, ["storage-tank"] = true, ["train-stop"] = true, ["loader"] = true, ["splitter"] = true, ["transport-belt"] = true, ["underground-belt"] = true, ["turret"] = true, ["ammo-turret"] = true, ["electric-turret"] = true, ["fluid-turret"] = true, ["wall"] = true}
Constants.EntityTypesNotOnOpponentLandOwnership = {["land-mine"] = true}

return Constants

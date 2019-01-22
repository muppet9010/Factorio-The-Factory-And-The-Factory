local Constants = {}

Constants.ModName = "the_factory_and_the_factory"
Constants.AssetModName = "__" .. Constants.ModName .. "__"

Constants.Teams = {
    team1 = {
        name = "team1",
        playerConstruction = true,
        displayName = "Beszel",
        colorName = "bright blue",
    },
    team2 = {
        name = "team2",
        playerConstruction = true,
        displayName = "UI Qoma",
        colorName = "dull orange"
    },
    breach = {
        name = "breach",
        playerConstruction = false,
        displayName = "Breach"
    }
}

Constants.PlayerConstructionTeams = {}
for _, team in pairs(Constants.Teams) do
    if team.playerConstruction then
        Constants.PlayerConstructionTeams[team.name] = Constants.Teams[team.name]
    end
end

Constants.LandClaims = {
    team1 = {
        name = "team1",
        landClaimImageName = "team",
        landClaimColor = {r= 102, g = 217, b = 255},
        landClaimName = "team1-land-claim",
        team = Constants.Teams["team1"]
    },
    team2 = {
        name = "team2",
        landClaimImageName = "team",
        landClaimColor = {r= 255, g = 153, b = 51},
        landClaimName = "team2-land-claim",
        team = Constants.Teams["team2"]
    }
}

Constants.LandClaimNames = {}
for k, landClaim in pairs(Constants.LandClaims) do
    Constants.LandClaimNames[landClaim.landClaimName] = Constants.LandClaims[landClaim.name]
end

Constants.CollisionMasks = {
    team1 = "layer-14",
    team2 = "layer-15"
}

Constants.LandClaimCollisionMaskLists = {
    team1 = {Constants.CollisionMasks.team1},
    team2 = {Constants.CollisionMasks.team2}
}

Constants.BuildingCollisionMaskLists = {
    team1 = {Constants.CollisionMasks.team2},
    team2 = {Constants.CollisionMasks.team1}
}

function Constants.MakeTeamSpecificThingName(team, thingName)
    return thingName .. "-" .. team.name
end

Constants.EntityTypesAffectedByLandOwnership = {["accumulator"] = true, ["artillery-turret"] = true, ["beacon"] = true , ["boiler"] = true, ["arithmetic-combinator"] = true, ["decider-combinator"] = true, ["constant-combinator"] = true, ["container"] = true, ["logistic-container"] = true, ["infinity-container"] = true, ["assembling-machine"] = true, ["rocket-silo"] = true, ["furnace"] = true, ["electric-pole"] = true, ["gate"] = true, ["generator"] = true, ["heat-pipe"] = true, ["inserter"] = true, ["lab"] = true, ["lamp"] = true,["mining-drill"] = true, ["offshore-pump"] = true, ["pipe"] = true, ["pipe-to-ground"] = true, ["power-switch"] = true, ["programmable-speaker"] = true, ["pump"] = true, ["radar"] = true, ["curved-rail"] = true, ["straight-rail"] = true, ["rail-chain-signal"] = true, ["rail-signal"] = true, ["reactor"] = true, ["roboport"] = true, ["solar-panel"] = true, ["storage-tank"] = true, ["train-stop"] = true, ["loader"] = true, ["splitter"] = true, ["transport-belt"] = true, ["underground-belt"] = true, ["turret"] = true, ["ammo-turret"] = true, ["electric-turret"] = true, ["fluid-turret"] = true, ["wall"] = true}
Constants.EntityTypesNotOnOpponentLandOwnership = {["land-mine"] = true}

return Constants

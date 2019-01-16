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

Constants.LandClaims = {
    none = {
        name = "none",
        landClaimImageName = "none",
        landClaimColor = {},
        landClaimName = "none-land-claim",
        team = nil
    },
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
    },
}
Constants.LandClaimNames = {}
for k, landClaim in pairs(Constants.LandClaims) do
    Constants.LandClaimNames[landClaim.landClaimName] = Constants.LandClaims[landClaim.name]
end

Constants.CollisionMasks = {
    none = "layer-12",
    anyTeam = "layer-13",
    team1 = "layer-14",
    team2 = "layer-15"
}

Constants.CollisionMaskLists = {
    none = {Constants.CollisionMasks.none},
    team1 = {Constants.CollisionMasks.anyTeam, Constants.CollisionMasks.team1},
    team2 = {Constants.CollisionMasks.anyTeam, Constants.CollisionMasks.team2}
}

return Constants

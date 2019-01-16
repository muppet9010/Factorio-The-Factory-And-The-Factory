local Constants = require("constants")


local function CreateLandClaim(landTileName)
    local landClaim = {
        type = "recipe",
        name = landTileName,
        energy_required = 0.5,
        category = "crafting",
        ingredients =
        {
            {"copper-plate", 1}
        },
        result = landTileName,
        enabled = false
    }
    data:extend({landClaim})
end


for k, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim.landClaimName)
    end
end

local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "recipe",
            name = landClaim.name,
            energy_required = 0.5,
            category = "crafting",
            ingredients =
            {
                {"copper-plate", 1}
            },
            result = landClaim.name,
            enabled = false
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    CreateLandClaim(landClaim)
end

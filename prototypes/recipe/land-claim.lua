local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "recipe",
            name = landClaim.landClaimName,
            energy_required = 0.5,
            category = "crafting",
            ingredients =
            {
                {"copper-plate", 1}
            },
            result = landClaim.landClaimName,
            enabled = false
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim)
    end
end

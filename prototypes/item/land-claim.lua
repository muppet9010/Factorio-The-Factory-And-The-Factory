local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "item",
            name = landClaim.landClaimName,
            icons = {
                {
                    icon = Constants.AssetModName .. "/graphics/icon/land-claim-" .. landClaim.landClaimImageName .. ".png",
                    icon_size = 64,
                    tint = landClaim.landClaimColor
                }
            },
            flags = {"goes-to-quickbar"},
            stack_size = 1000,
            place_result = landClaim.landClaimName,
            subgroup = "terrain",
            order = "_[stone-brick]"
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim)
    end
end

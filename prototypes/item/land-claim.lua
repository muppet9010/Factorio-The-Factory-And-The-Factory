local Constants = require("constants")


local function CreateLandClaim(tileColor, imageNameEnd, landTileName)
    local landClaim = {
        type = "item",
        name = landTileName,
        icons = {
            {
                icon = Constants.AssetModName .. "/graphics/icon/land-claim-" .. imageNameEnd .. ".png",
                icon_size = 64,
                tint = tileColor
            }
        },
        flags = {"goes-to-quickbar"},
        stack_size = 1000,
        place_result = landTileName,
        subgroup = "terrain",
        order = "_[stone-brick]"
    }
    data:extend({landClaim})
end


for k, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim.landClaimColor, landClaim.landClaimImageName, landClaim.landClaimName)
    end
end

local Constants = require("constants")


local function CreateLandClaim(landClaim)
    local landclaimItem = {
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
        subgroup = "terrain",
        order = "_[stone-brick]"
    }
    if settings.startup["landclaim-mode"].value == "entity" then
        landclaimItem.place_result = landClaim.landClaimName
    elseif settings.startup["landclaim-mode"].value == "tile" then
        landclaimItem.place_as_tile = {
            result = landClaim.landClaimName,
            condition_size = 1,
            condition = { "water-tile" }
        }
    end

    data:extend({landclaimItem})
end


for _, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim)
    end
end

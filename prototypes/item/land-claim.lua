local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "selection-tool",
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
            order = "_[stone-brick]",
            selection_color = {a=0},
            alt_selection_color = {a=0},
            selection_mode = {"any-tile"},
            alt_selection_mode = {"any-tile"},
            selection_cursor_box_type = "copy",
            alt_selection_cursor_box_type = "not-allowed"
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    if landClaim.team ~= nil then
        CreateLandClaim(landClaim)
    end
end

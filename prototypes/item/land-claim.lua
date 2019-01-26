local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "selection-tool",
            name = landClaim.name,
            icons = {
                {
                    icon = Constants.AssetModName .. "/graphics/icon/land-claim-" .. landClaim.entityImageName .. ".png",
                    icon_size = 64,
                    tint = landClaim.color
                }
            },
            flags = {"goes-to-quickbar"},
            stack_size = 1000,
            subgroup = "terrain",
            order = "_[stone-brick]",
            selection_color = Constants.Color.Invisible,
            alt_selection_color = Constants.Color.Invisible,
            selection_mode = {"any-tile"},
            alt_selection_mode = {"any-tile"},
            selection_cursor_box_type = "copy",
            alt_selection_cursor_box_type = "not-allowed"
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    CreateLandClaim(landClaim)
end

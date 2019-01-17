local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "simple-entity",
            name = landClaim.landClaimName,
            icons = {
                {
                    icon = Constants.AssetModName .. "/graphics/entity/land-claim-" .. landClaim.landClaimImageName .. ".png",
                    icon_size = 64,
                    tint = landClaim.landClaimColor
                }
            },
            order = landClaim.landClaimName,
            picture = {
                filename = Constants.AssetModName .. "/graphics/entity/land-claim-" .. landClaim.landClaimImageName .. ".png",
                width = 64,
                height = 64,
                tint = landClaim.landClaimColor,
                scale = 0.5
            },
            render_layer = "ground-patch-higher2",
            collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
            collision_mask = Constants.LandClaimCollisionMaskLists[landClaim.name],
            selection_box = {{-0.45, -0.45}, {0.45, 0.45}},
            flags = {"not-rotatable", "not-on-map", "placeable-player", "not-blueprintable", "not-deconstructable"},
            selectable_in_game = false
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    CreateLandClaim(landClaim)
end

local Constants = require("constants")


local function CreateLandClaim(landClaim)
    data:extend({
        {
            type = "simple-entity-with-force",
            name = landClaim.name,
            icons = {
                {
                    icon = Constants.AssetModName .. "/graphics/entity/land-claim-" .. landClaim.entityImageName .. ".png",
                    icon_size = 64,
                    tint = landClaim.color
                }
            },
            order = landClaim.name,
            picture = {
                filename = Constants.AssetModName .. "/graphics/entity/land-claim-" .. landClaim.entityImageName .. ".png",
                width = 64,
                height = 64,
                tint = landClaim.color,
                scale = 0.5
            },
            render_layer = "ground-patch-higher2",
            collision_box = {{-0.45, -0.45}, {0.45, 0.45}},
            collision_mask = landClaim.collisionMaskList,
            selection_box = {{-0.45, -0.45}, {0.45, 0.45}},
            flags = {"not-rotatable", "not-on-map", "placeable-player", "not-blueprintable", "not-deconstructable"},
            selectable_in_game = false
        }
    })
end


for _, landClaim in pairs(Constants.LandClaims) do
    CreateLandClaim(landClaim)
end

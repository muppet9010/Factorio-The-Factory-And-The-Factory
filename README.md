# Factorio-The-Factory-And-The-Factory

2 peasefully competing factories are arising intertwined on this strange planet, born from the equally entwined earth cities of Beszel and UI Qoma. While they share the same physical space their engineers must "unsee" the neighbouring factory and all events that take place there. This seperation is vigerously enforced by an agency called Breach. The 2 factories are in a race to better support their home city back on earth above their neighbor.

Based on the concepts from the noval The City & the City by China Mieville



Terminology:
Unsee: to unsee is to ignore the existence of the other factory entirely. This includes its engineers, buildings and the activites of biters interacting with the other factory.
Total Area: an area that YOUR facotry fully owns and the other team must fully unsee.
Alter Area: an area the the OTHER factory fully owns and you must fully unsee.
Crosshatched Area: a previously Total Area that a the other team has upgraded to have foot/vehicle access across. Can have primary teams buildings on it.
Breach: the organisation that polices the seperation of the 2 factories and the unseeing process.
Breach Agent: the agents who detain engineers in the case of a breach. May be real players or autonamous robots.


Done v1:
 - ground (non water) map tiles are claimed by a team using a land claim marker (team tile). team tiles cost 1 copper to make.
 - you may only place all buildings and landmines on team tiles or unclaimed tiles. they will be blocked by the game on other team's tiles.
 - 2 new teams for the factories, each set to enemy with each other, but with a mutual cease fire. so can't interact with each others stuff, but won't automatically shoot each other.
 - breach team is allied to everyone including biters
 - a team tile is crafted and is a selection tool item to draw the area you want to claim. allowing varying sized areas at a time. it will then claim the selected tiles as approperiate.
 - a team tile item has an alternative function of removing team tiles that don't have buildings on them.
 - placing buildings (not landmines) on unclaimed tiles will automatically place team tiles if you/storage has enough. otherwise the building will be returned to the player.
 - you can not remove land claim from under a building that needs it
 - you can not place a land claim on top of another teams land claim
 - power poles don't attach to other team (connections removed by mod)
 - players can change team via command or admins can move them via command
 - add a large wooden power pole with long wire reach, but no powered area. effectient for taking power across unclaimed land early on. (seperate mod, but as pre-req)
 - power poles can only be placed where their entire powered radius can have team tiles placed under them. on placing the power pole team tiles for their powered radius will be takne from the player and placed. otherwise the pole will be ripped up and returned.
 - start the game with a box of 100 land claims per team


TODO v1:
 - positioned collision box (Utils.ApplyBoundingBoxToPosition) needs to account for the rotation of the entity - causing offshore pump to go wrong
 - landclaim tool can't remove claim tiles which are powered
 - robots placing power poles have same behaviour as when players placing them.
 - robots placing buildings have same behaviour and restrictions as players, take land claim from logic network magically or cancel ghost.
 - a team's tile can be placed on another teams tile to create a crosshatched area if the space is unoccupied. the team making the crosshatch must have their new crosshatch tile connected to another of their tiles or crosshatchs.
 - nothing can be built on a cross hatched area by either team.
 - power poles can be built while powering cross hatched areas?
 - add a tag to player names to show which team they are on, maybe force colours on them?

 - go on tile that is claimed by the other team = breach
 - if damage other team or their buildings (other than landmines) = breach
 - if kill biters on other teams tiles or while attacking other teams buildings = breach
 - interact with other teams belts or rails = breach
 - manually connect to other teams eletric or circuit network = breach
 - drop items on other teams tiles = breach
 - players can change team via command or join breach
 - breach agents are units that phase in from main buildings and slowly hunt the player. they detain when physical contact is made and player is held as a breacher for some time based on crime. maybe some sort of armed breach agent from headquarters as well.
 - players can be breach agents, they do breach agent jobs and can not interact with any of the real world. they are breach models and effects.
 - killing/attacking a breach agent is a seious offence

 - Players can change factory alliangence, visit the other factory and join the breach team via the Copula Hall (breach and invunverable).
 - When players change team or visit the other team you leave everything behind in a team box at copula hall, no ability to rob other team. Applies to command or via GUI (Copula Hall)
 - when you pickup an item from the ground or spawn with anything it is convert it to be your team specific version.


Issues:
 - how do you build a new track past/across the other teams track. belts you can underground.
 - crosshatching can be exploited as an offensive move to frustrate your opponent.
 - to get crosshatching past belts and rails may be impossible while they require ownernship, should they be immune from owenership and not prevent cross hatching?


Ideas:
 - method to object to other factions activities in an area
 - pay to esclate towards war
 - train tunnel mod should come out post 0.17. works in concept in 0.16
 - some sort of expensive underground passway for players and belts?
 - rather than placing individual land placement tiles you have a bidding mechanism for buying whole plots.
 - map starts with a random grid of cross hatched paths so everyone knows where they are from the start. allow short distance of track to be built across it. narrow enough belts can cross it. also maybe thin pre owned land lanes across the map to avoid lock in at belt stages
 - landclaim tile get more expensive over time
 - frequently changing item requests like supply mission. over a set game time. gets harder and longer time as it progresses
 - points for sending back resources throughout the game. value per resource goes down in a market mechanic
 - race to X rockets launched as built in win option?
 - reserved tile. costs more but can't be cross hatched by the opponent
 - rails can cross on cross hatch, but not join. need to avoid griefing with trains however.
 - loot/rewards out in the map to be explored and found (seperate mod if not already)


0.17 limitations resolved:
 - make building fully visible to own team and distorted to opponents using the new render options
 - show opposing players all as the same color of their team. own team sees own players in chosen color
 - selection tool allows filtering by entity prototype, rather than just all entities like current in 0.16. kept one tool per team so can use this in future. at present due to 0.16 bug
 - flying text feedback message can be shown to only 1 player and not everyone



Technical links:
https://github.com/shanemadden/factorio-power-grid-comb/blob/master/control.lua
https://github.com/mspielberg/factorio-miniloader/blob/master/lualib/onwireplaced.lua

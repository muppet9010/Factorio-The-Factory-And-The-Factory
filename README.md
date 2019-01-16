# Factorio-The-Factory-And-The-Factory

2 duelling factories are arising intertwined on this strange planet, born from the equally entwined earth cities of Beszel and UI Qoma. While they share the same physical space their engineers must "unsee" the neighbouring factory and all events that take place there. This seperation is vigerously enforced by an agency called Breach. The 2 factories are in a bitter race to better support their home city back on earth above their neighbor.

Based on the concepts from the noval The City & the City by China Mieville



Terminology:
Unsee: to unsee is to ignore the existence of the other factory entirely. This includes its engineers, buildings and the activites of biters interacting with the other factory.
Total Area: an area that YOUR facotry fully owns and the other team must fully unsee.
Alter Area: an area the the OTHER factory fully owns and you must fully unsee.
Crosshatched Area: an area that BOTH factories can use to pass through, but neither can build on.
Breach: the organisation that polices the seperation of the 2 factories and the unseeing process.
Breach Agent: the agents who detain engineers in the case of a breach. May be real players or autonamous robots.



TODO v1:
 - 2 forces each set to ally, but can't interact with each others buildings, etc
 - breach is allied to everyone including biters
 - tiles are claimed by a team using a land claim tile (team tile). tiles cost 1 iron or 1 copper to make and you start the game with 100 per team. a team tile is the tile and not a surface type.
 - a team's tile can be placed on another teams tile to create a crosshatched area if there is nothing on the tile.
 - nothing can be built on a cross hatched area by either team.
 - power poles don't attach to other team
 - power poles can only be placed where their entire powered radius can have team tiles placed under them
 - color overlay or fog on other teams buildings to distinguish
 - go on tile that is claimed by the other team = breach
 - if damage other team or their buildings = breach
 - if kill biters on other teams tiles or while attacking other teams buildings = breach
 - interact with other teams belts or rails = breach
 - manually connect to other teams eletric or circuit network = breach
 - drop items on other teams tiles = breach
 - players can change team via command or join breach
 - breach agents are units that phase in from main buildings and slowly hunt the player. they detain when physical contact is made and player is held as a breacher for some time based on crime.
 - players can be breach agents, they do breach agent jobs and can not interact with any of the real world. they are breach models and effects.
 - killing/attacking a breach agent is a seious offence
 - Players can change factory and join breach via the Copula Hall.


Done v1:


 Ideas:
 - method to object to other factions activities in an area and go to war after multiple objections
 - some mods or new things that the 2 teams can compete to do.


0.17:
 - make building fully visible to own team and distorted to opponents using the new render options




https://github.com/shanemadden/factorio-power-grid-comb/blob/master/control.lua
https://github.com/mspielberg/factorio-miniloader/blob/master/lualib/onwireplaced.lua

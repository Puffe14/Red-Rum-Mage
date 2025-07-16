extends Special
class_name Spell

#parameters for thespell
@export var part = "" # which bar is effected
@export var type = "" # area type
@export var cost: float # how much mp
@export var time: float # how long to cast
# preload the projectile scene
const projectilename = "res://rocko.tscn"
const projectile = preload(projectilename)

# add this spell to a player's spellbook
func addToBook(player: Player):
	player.addSpell(self)

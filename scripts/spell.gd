extends Special
class_name Spell

#parameters for the spell
@export var part = "" # which bar is effected
@export var type = "" # area type
@export var cost: float # how much mp
@export var time: float # how long to cast
@export var projectile: PackedScene = null # insert the projectile scene

func _init() -> void:
	color = "purple"

# add this spell to a player's spellbook
func addToBook(player: Player):
	player.addSpell(self)

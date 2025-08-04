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
	describe = "Spell - {name}: Cost {cost}\n Target: {target}, ARM: {hands}%, LEG: {legs}%\n{desc}".format(
		{"cost":cost, "name":title, "target":targeting, "hands": bar1, "legs" :bar2, "desc":description}
	)

# add this spell to a player's spellbook
func addToBook(player: Player):
	player.add_spell(self)

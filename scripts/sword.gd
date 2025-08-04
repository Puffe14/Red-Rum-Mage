class_name Sword extends Card
@export var atk: int
@export var spd: int
@export var lifesteal: int
#@export var model: PackedScene = null # insert the swords model scene

func _init() -> void:
	color = "pink"
	describe = "Sword - {name}:\n Atk: {atk}%, Spd: {spd}%, Lifesteal: {ls}%, \n{desc}".format(
		{"name":title, "ls":lifesteal, "atk": atk, "spd" :spd, "desc":description}
	)

func onPick(player: Player):
	player.equipSword(self)

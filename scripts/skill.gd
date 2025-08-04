class_name Skill extends Special

func _init() -> void:
	color = "blue"
	describe = "Skill - {name}: Damage {dmg}%\n Target: {target}, ARM: {hands}%, LEG: {legs}%\n{desc}".format(
		{"dmg":dmg, "name":title, "target":targeting, "hands": bar1, "legs" :bar2, "desc":description}
	)

# add this skill to a player's skillbook
func addToBook(player: Player):
	player.add_skill(self)

func canDo(b1: int, b2: int) -> bool:
	return b1 >= -bar1 && b2 >= -bar2

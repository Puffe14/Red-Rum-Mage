class_name Skill extends Special

func _init() -> void:
	color = "blue"

# add this skill to a player's skillbook
func addToBook(player: Player):
	player.addSkill(self)

func canDo(b1: int, b2: int) -> bool:
	return b1 >= -bar1 && b2 >= -bar2

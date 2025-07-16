class_name Special extends Card

@export var targeting: Targeting
# how much the bars are effected, and damage by percentage
@export var bar1: int
@export var bar2: int
@export var dmg: int

func onPick(player: Player):
	addToBook(player)

# adds a new spell to the players spell book or new skill to skill book
# defined in subclasses
func addToBook(player: Player):
	pass

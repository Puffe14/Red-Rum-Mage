class_name card_node extends Control

@export var card: Card
@export var selected: bool
const me = preload("res://scenes/card_node.tscn")

func setCard(new_card: Card) -> void:
	card = new_card

#create a new card node based on the given card and return it
static func build(new_card: Card):
	var new = me.instantiate()
	new.setCard(new_card)
	return new

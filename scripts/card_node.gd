class_name card_node extends MarginContainer

@export var card: Card
@export var selected: bool
const me = preload("res://scenes/card_node.tscn")
var texture_map = { "blue": load("res://image/ui/card blue.png"),
					"green": load("res://image/ui/card green.png"),
					"purple": load("res://image/ui/card purple.png"),
					"pink": load("res://image/ui/card pink.png"),
					"red": load("res://image/ui/card red.png"),
					"none": load("res://image/ui/card blank.png") }

#set all the card node's info based on the given card
func setCard(new_card: Card) -> void:
	card = new_card
	$VBoxContainer/CardPic/CardFrame.texture = texture_map[card.color]
	$VBoxContainer/CardPic/CardIcon.texture = card.icon
	$VBoxContainer/TitleText.text = card.title

#create a new card node based on the given card and return it
static func build(new_card: Card):
	var new = me.instantiate()
	new.setCard(new_card)
	return new

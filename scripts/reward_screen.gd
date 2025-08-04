class_name reward_screen extends Control
@export var cards: Array[Card]

func setCards(new_cards: Array[Card]) -> void:
	cards = new_cards
	createCardNodes()

#create all the card nodes
func createCardNodes():
	for card in cards:
		var cardNode: card_node = card_node.build(card)
		$HBoxCards.add_child(cardNode)

static func build(new_cards: Array[Card]):
	var me = load("res://scenes/reward_screen.tscn")
	var new = me.instantiate()
	new.setCards(new_cards)
	return new

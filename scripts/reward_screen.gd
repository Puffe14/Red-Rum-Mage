class_name reward_screen extends Control
@export var cards: Array[Card]
@export var index: int = 0
var player: Player = null

func setCards(new_cards: Array[Card]) -> void:
	cards = new_cards
	createCardNodes()

#create all the card nodes
func createCardNodes():
	for card in cards:
		card._setter()
		var cardNode: card_node = card_node.build(card)
		$VBox/HBoxCards.add_child(cardNode)

static func build(new_cards: Array[Card]):
	var me = load("res://scenes/reward_screen.tscn")
	var new = me.instantiate()
	new.setCards(new_cards)
	return new

func close():
	print("exited reward screen")
	queue_free()

func _process(delta: float) -> void:
	#change index for menu
	if Input.is_action_just_pressed("cam_right"):
		index += 1
	elif Input.is_action_just_pressed("cam_left"):
		index -=1
	elif Input.is_action_just_pressed("hit"):
		cards[index].onPick(player)
		close()
	#check for index out of bounds
	if index < 0:
		index = 0
	if index > cards.size() - 1:
		index = cards.size() - 1
	$VBox/Description.text = cards[index].describe
	for card in $VBox/HBoxCards.get_children():
		card.scale = Vector2(1, 1)
		if card.card == cards[index]:
			card.scale = Vector2(1.25, 1.25)

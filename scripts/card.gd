class_name Card extends Resource

# Sets which card color and icon will be used
@export var color = "none"
@export var icon: CompressedTexture2D = preload("res://image/icons/unknown.png")
# Set the text for the card
@export var title: String = "card" 
@export var description: String = "default card"
var describe: String = description

enum Targeting{Self,Shoot,Target}

func onPick(player: Player):
	pass

func _setter():
	pass

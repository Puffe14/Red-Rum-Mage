class_name Card extends Resource

# Sets which card color and icon will be used
const color = "blue"
const icon = "icon.png"
# Set the text for the card
const title: String = "card" 
const description: String = "default card"

enum Targeting{Self,Shoot,Target}

func onPick(player: Player):
	pass

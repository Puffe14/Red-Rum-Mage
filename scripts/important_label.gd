extends Label

var mhp = 0
var mmp = 0
var hp = 0
var mp = 0
var pt = 0
var b1 = 0
var b2 = 0
var playerNode


func _ready() -> void:
	text = "HP: {health}/{maxhealth} \n MP: {magic}/{maxmagic}".format({"health":hp, "maxhealth":mhp, "magic":mp, "maxmagic":mmp})
	var playerGroup = get_tree().get_nodes_in_group("player")
	if playerGroup.size() > 0:
		playerNode = playerGroup[0] 
		
func _process(delta: float) -> void:
	mhp = playerNode.mhp
	mmp = playerNode.mmp
	hp = playerNode.hp
	mp = playerNode.mp
	pt = playerNode.pots
	b1 = playerNode.bar1
	b2 = playerNode.bar2
	text = "HP: {health}/{maxhealth} \nMP: {magic}/{maxmagic}\nPots: {pots} \nB1: {ba1} \nB2: {ba2}".format({"health":hp, "maxhealth":mhp, "magic":mp, "maxmagic":mmp, "pots":pt, "ba1":b1, "ba2":b2})
	text += "\nTimer: %s" %(floor(playerNode.currentTime*100)/100)

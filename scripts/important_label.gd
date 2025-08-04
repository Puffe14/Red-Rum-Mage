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
	#set all rooms to have player
	var rooms = get_tree().get_nodes_in_group("room")
	for room in rooms:
		room.player = playerNode
	
	mhp = playerNode.mhp
	mmp = playerNode.mmp
	hp = playerNode.hp
	mp = playerNode.mp
	pt = playerNode.pots
	b1 = playerNode.bar1
	b2 = playerNode.bar2
	var hpb: TextureProgressBar = $MarginContainer/VBoxContainer/BottomHBox/HP/GaugeHP
	var mpb: TextureProgressBar = $MarginContainer/VBoxContainer/BottomHBox/MP/GaugeMP
	var sb1: TextureProgressBar = $MarginContainer/VBoxContainer/BottomHBox/SpellGauges/B1/GaugeB1
	var sb2: TextureProgressBar = $MarginContainer/VBoxContainer/BottomHBox/SpellGauges/B2/GaugeB2
	var b1l: Label = $MarginContainer/VBoxContainer/BottomHBox/SpellGauges/B1/PRC
	var b2l: Label = $MarginContainer/VBoxContainer/BottomHBox/SpellGauges/B2/PRC
	var hpl: Label = $MarginContainer/VBoxContainer/BottomHBox/HP/PRC
	var mpl: Label = $MarginContainer/VBoxContainer/BottomHBox/MP/PRC
	hpb.set_value_no_signal(hp)
	hpb.max_value = mhp
	mpb.set_value_no_signal(mp)
	mpb.max_value = mmp
	sb1.set_value_no_signal(b1)
	sb2.set_value_no_signal(b2)
	b1l.text = "%s" %b1
	b2l.text = "%s" %b2
	hpl.text = "HP: {health}/{maxhealth}".format({"health":hp, "maxhealth":mhp})
	mpl.text = "MP: {magic}/{maxmagic}".format({"magic":mp, "maxmagic":mmp})
	#$MarginContainer/HBoxContainer/Bars/Bar/Count.max_value = mhp
	text = "Pots: %s" %pt
	text += "\nTimer: %s" %(floor(playerNode.currentTime*100)/100)

extends Mob
class_name Player
#stats!wwwdssa

#balancebars
@export var bar1 = 0
@export var bar2 = 0
#atk swrd/mag
@export var satk = 1
@export var matk = 2
@export var potency = 3
# sword used and potions left
@export var pots: int = 2
@export var sword: Sword
# list of accumulated enhanchements (buffs/debuffs)
@export var enhancements: Array[Enhance]

#non stat variables
@export var alive: bool = true
@export var emote: String = "SMH"
@export var spelling: bool = false
@export var skilling: bool = false
@export var base_icons: Array[CompressedTexture2D]

var curAnim
#casting and timer
var interrupted = false
var casting = false
@export var currentTime = 0
#time for invincibility
@export var itime = 0.8
var itimer = 0


#signals
signal hurt
signal cast(projectile, direction, location)

#options
@export var update_movement_directions_only_on_stop: bool 

#physics
# gravity when in air, m/s^2
@export var fall_acceleration = 75
#impulse for jumping
@export var jump_impulse = 20
#stores speed and direction
var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var facing = Vector3.ZERO
var pivot_basis = null

#boolean for insert buttonpress
func bp(button: String) -> bool:
	if Input.is_action_pressed(button):
		return true
	else:
		return false




#spells and skills in books and slots
@export var spellSlots: Array[Spell]
@export var skillSlots: Array[Skill]
@export var spellBook: Array[Spell]
@export var skillBook: Array[Skill]
var curSpell: Spell = null #spellSlots.hotb1
var curSkill: Skill = null

func add_spell(new_spell: Spell):
	spellBook.append(new_spell)
	spellSlots = spellBook.slice(0,3)
func add_skill(new_skill: Skill):
	skillBook.append(new_skill)
	skillSlots = skillBook.slice(0,3)

func playAnim(str: String) -> void:
	$Pivot/chocuf/AnimationPlayer.play(str)

#player FIRES SPELL
func fire_spell():
	if mp - curSpell.cost >= 0:
		if curSpell.type == "blast":
			playAnim("Blast")
		if curSpell.type == "kick":
			playAnim("Kick")
		#makes player lose appropriate mp
		mp -= curSpell.cost
		#and gain bar
		bar1Change(curSpell.bar1)
		bar2Change(curSpell.bar2)
		#casts a magic projectile
		cast.emit(curSpell.projectile, facing, position, 30)
	else: 
		playAnim("Hurt")
	casting = false

var ontheground = false


func _physics_process(delta: float) -> void:
	if curSpell==null:
		curSpell = spellBook[0]
		curSkill = skillBook[0]
		spellSlots = spellBook.slice(0,3)
		skillSlots = skillBook.slice(0,3)
		pivot_basis = $HorizontalPivot.basis #$Pivot/chocuf/metarig.basis
		#$Player/HorizontalPivot.basis #/VerticalPivot/SpringArm3D/Camera3D #$Pivot/chocuf/metarig.basis

	# handle DEATH
	if not alive:
		if not ontheground:
			ontheground = true
			playAnim("Death")
			
		return
	#checks if player is alive
	alive = hp > 0
	#current movement
	direction = Vector3.ZERO
	#updates invincibility
	itimer += delta
	
	#can't moven when just hurt
	#if itime < itimer/4:
	#	return
	
	#update movement directions
	if !update_movement_directions_only_on_stop:
		pivot_basis = $HorizontalPivot.basis 
	
	#Check each move input and change direction
	if Input.is_action_pressed("move_right"):
		direction += pivot_basis.x.normalized()
	if Input.is_action_pressed("move_left"):
		direction -= pivot_basis.x.normalized()
	if Input.is_action_pressed("move_back"):
		direction += pivot_basis.z.normalized()
	if Input.is_action_pressed("move_forward"):
		direction -= pivot_basis.z.normalized()
	
	#Check whether the player is accessing the hotbar for skills or spells
	if bp("skill"):
		skilling = true
		spelling = false
	elif bp("spell"):
		spelling = true
		skilling = false
	else:
		spelling = false
		skilling = false

	#check if should run or walk
	if bp("move_right") || bp("move_left") || bp("move_back") || bp("move_forward"):
		if bp("run") and curAnim != "jump":
			playAnim("Run loop")
			speed = 5
		elif curAnim != "jump":
			playAnim("Walk loop")
			speed = 2
		$Pivot/chocuf/AnimationPlayer.speed_scale = 2
	else:
		if update_movement_directions_only_on_stop:
			pivot_basis = $HorizontalPivot.basis
		#pivot_basis = $Pivot/chocuf/metarig.basis

	#jumping
	if is_on_floor() and bp("jump") and curAnim != "jump":
		target_velocity.y = jump_impulse
		playAnim("Jump")
		$Pivot/chocuf/AnimationPlayer.speed_scale = 1
	
	curAnim = $Pivot/chocuf/AnimationPlayer.current_animation
	
	#if player moved, normalizes and rotates player
	if direction != Vector3.ZERO:
		#moves it only by 1?
		direction = direction.normalized()
		#basis affects the rotation, editing basis edits rotation
		$Pivot/chocuf/metarig.basis = Basis.looking_at(direction)
		#sets where player is facing
		facing = direction.normalized()
	#if still
	elif curAnim == "Walk loop" || curAnim == "Run loop":
		#await get_tree().create_timer(1).timeout
		$Pivot/chocuf/AnimationPlayer.speed_scale = 0.3
		playAnim("Idle loop")

	#sets target vector
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#if midair, falls
	if not is_on_floor():
		target_velocity.y = target_velocity.y -(fall_acceleration * delta)
	
	#use hot bar to set spell or skill action
	if spelling:
		if bp("hotb1"):
			curSpell = spellSlots[0]
		if bp("hotb2"):
			curSpell = spellSlots[1]
		if bp("hotb3"):
			curSpell = spellSlots[2]
		if bp("hotb3"):
			curSpell = spellSlots[3]
	if skilling:
		if bp("hotb1"):
			curSkill = skillSlots[0]
		if bp("hotb2"):
			curSkill = skillSlots[1]
		if bp("hotb3"):
			curSkill = skillSlots[2]
		if bp("hotb3"):
			curSkill = skillSlots[3]
	
	#player skills
	if skilling && bp("cast") && actionable():
		if curSkill.canDo(bar1,bar2):
			bar1Change(curSkill.bar1)
			bar2Change(curSkill.bar2)
			$Pivot/chocuf/AnimationPlayer.speed_scale = 1
			playAnim("Atk Stab")
		else:
			$Pivot/chocuf/AnimationPlayer.speed_scale = 1
			playAnim("Wave loop")
	#player attacks
	elif bp("hit"):
		$Pivot/chocuf/AnimationPlayer.speed_scale = 2
		if curAnim == "Atk Swing":
			playAnim("Atk Stab")
		else:
			playAnim("Atk Swing")
	#updates current time with delta if casting
	if casting == true:
		$Pivot/chocuf/AnimationPlayer.speed_scale = 1
		currentTime += delta
	#player begins to cast spell
	if spelling && bp("cast"):
		currentTime = 0
		casting = true
		if curSpell.part == "hand":
			playAnim("Cast hand")
		if curSpell.part == "foot":
			playAnim("Cast foot")
	#interrupts spell if the player moves
	elif interrupted or casting == true && !bp("spell") && Input.is_anything_pressed():
		casting = false
		interrupted = false
		print("casting interrupted")
	#if the the castTime passes after starting spell
	elif curSpell.time < currentTime && casting == true:
		fire_spell()
	
	#player uses a consumable
	if bp("eat") && curAnim != "Eat":
		$Pivot/chocuf/AnimationPlayer.speed_scale = 0.8
		if pots > 0:
			playAnim("Eat")
			pots -= 1
			hpChange(potency)
		else:
			playAnim(emote)
	
	#player emotes
	if bp("emote"):
		$Pivot/chocuf/AnimationPlayer.speed_scale = 0.8
		playAnim(emote)
	
	#move character
	velocity = target_velocity
	move_and_slide()


func bar1Change(dif: int):
	bar1 += dif
	if bar1>100:
		bar1 = 100
	elif bar1<0:
		bar1 = 0

func bar2Change(dif: int):
	bar2 += dif
	if bar2>100:
		bar2 = 100
	elif bar2<0:
		bar2 = 0

func _on_hurtplayer(dealt:int) -> void:
	if alive and itimer >= itime:
		itimer = 0
		#player gets hurt
		print("player HURT")
		$Pivot/chocuf/AnimationPlayer.speed_scale = 1
		playAnim("Hurt")
		interrupted = true
		hpChange(-dealt)
	else: print("invulnerable")

func actionable() -> bool:
	return !["Hurt","Atk Stab","Atk Swing"].has(curAnim)

func equipSword(new_sword: Sword) -> void:
	sword = new_sword
	#$Pivot/chocuf/metarig/Skeleton3D/BoneAttachmentWeapon/Rapier.scale = sword.atk/100.0

extends CharacterBody3D
class_name Player
#stats!wwwdssa
#hp/mp
@export var hp = 10
@export var mp = 25

#hp/mp
@export var mhp = 10
@export var mmp = 25
#balancebars
@export var bar1 = 0
@export var bar2 = 0
#player movement speed in m/s
@export var speed = 6
#atk swrd/mag
@export var satk = 1
@export var matk = 2
@export var pote = 3
# sword used and potions left
@export var pots: int = 2
@export var sword: Sword
# list of accumulated enhanchements (buffs/debuffs)
@export var enhancements: Array[Enhance]

#non stat variables
@export var alive: bool = true
@export var emote: String = "SMH"
var curAnim
#casting and timer
var interrupted = false
var casting = false
@export var currentTime = 0
#time for invincibility
var itime = 0.8
var itimer = 0


#signals
signal hurt
signal cast(projectile, direction, location)


#projectiles
const projectiles ={"rocko": preload("res://rocko.tscn"), 
			   		"flam":  preload("res://flam.tscn")}


#physics
# gravity when in air, m/s^2
@export var fall_acceleration = 75
#impulse for jumping
@export var jump_impulse = 20
#stores speed and direction
var target_velocity = Vector3.ZERO
var direction = Vector3.ZERO
var facing = Vector3.ZERO

#boolean for insert buttonpress
func bp(button: String) -> bool:
	if Input.is_action_pressed(button):
		return true
	else:
		return false



#spells
const rocko = {"name": "rocko", 
			   "part": "foot",
			   "type": "kick", 
			   "cost": 2, 
			   "time": 2.5}

const flam = {"name": "flam",
			  "part": "hand", 
			  "type": "blast", 
			  "cost": 5, 
			  "time": 1.5}

#spellslots
var spellSlots = {"hotb1": rocko, "hotb2": flam}
@export var spellBook: Array[Spell]
@export var skillBook: Array[Skill]
var curSpell: Spell = null #spellSlots.hotb1
var curSkill: Skill = null

func add_spell(new_spell: Spell):
	spellBook.append(new_spell)
func add_skill(new_skill: Skill):
	skillBook.append(new_skill)


#player FIRES SPELL
func fire_spell():
	if mp - curSpell.cost >= 0:
		if curSpell.type == "blast":
			$Pivot/chocuf/AnimationPlayer.play("Blast")
		if curSpell.type == "kick":
			$Pivot/chocuf/AnimationPlayer.play("Kick")
		#makes player lose appropriate mp
		mp -= curSpell.cost
		#and gain bar
		bar1Change(curSpell.bar1)
		bar2Change(curSpell.bar2)
		#casts a magic projectile
		cast.emit(curSpell.projectile, facing, position, 30)	
	else: 
		$Pivot/chocuf/AnimationPlayer.play("Hurt")
	casting = false

var ontheground = false

func _physics_process(delta: float) -> void:
	if curSpell==null:
		curSpell = spellBook[0]
		curSkill = skillBook[0]
		spellSlots = {"hotb1": spellBook[0], "hotb2": spellBook[1]}

	if not alive:
		if not ontheground:
			ontheground = true
			$Pivot/chocuf/AnimationPlayer.play("Death")
			
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
	
	#Check each move input and change direction
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	#check if should run or walk
	if bp("move_right") || bp("move_left") || bp("move_back") || bp("move_forward"):
		if bp("run") and curAnim != "jump":
			$Pivot/chocuf/AnimationPlayer.play("Run loop")
			speed = 5
		elif curAnim != "jump":
			$Pivot/chocuf/AnimationPlayer.play("Walk loop")
			speed = 2
		$Pivot/chocuf/AnimationPlayer.speed_scale = 2
	
	#jumping
	if is_on_floor() and Input.is_action_pressed("jump") and curAnim != "jump":
		target_velocity.y = jump_impulse
		$Pivot/chocuf/AnimationPlayer.play("Jump")
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
		$Pivot/chocuf/AnimationPlayer.play("Idle loop")

	#sets target vector
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	#if midair, falls
	if not is_on_floor():
		target_velocity.y = target_velocity.y -(fall_acceleration * delta)
	
	#use hot bar to set spell action
	if bp("hotb1"):
		curSpell = spellSlots.hotb1
	if bp("hotb2"):
		curSpell = spellSlots.hotb2
	if bp("hotb3"):
		curSkill = skillBook[0]
	
	#player skills
	if bp("skills") && actionable():
		if curSkill.canDo(bar1,bar2):
			bar1Change(curSkill.bar1)
			bar2Change(curSkill.bar2)
			$Pivot/chocuf/AnimationPlayer.speed_scale = 1
			$Pivot/chocuf/AnimationPlayer.play("Atk Stab")
		else:
			$Pivot/chocuf/AnimationPlayer.speed_scale = 1
			$Pivot/chocuf/AnimationPlayer.play("Wave loop")
	#player attacks
	elif bp("hit"):
		$Pivot/chocuf/AnimationPlayer.speed_scale = 2
		if curAnim == "Atk Swing":
			$Pivot/chocuf/AnimationPlayer.play("Atk Stab")
		else:
			$Pivot/chocuf/AnimationPlayer.play("Atk Swing")
	#updates current time with delta if casting
	if casting == true:
		$Pivot/chocuf/AnimationPlayer.speed_scale = 1
		currentTime += delta
	#player begins to cast spell
	if bp("spell"):
		currentTime = 0
		casting = true
		if curSpell.part == "hand":
			$Pivot/chocuf/AnimationPlayer.play("Cast hand")
		if curSpell.part == "foot":
			$Pivot/chocuf/AnimationPlayer.play("Cast foot")
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
			$Pivot/chocuf/AnimationPlayer.play("Eat")
			pots -= 1
			hpChange(pote)
		else:
			$Pivot/chocuf/AnimationPlayer.play(emote)
	
	#player emotes
	if bp("emote"):
		$Pivot/chocuf/AnimationPlayer.speed_scale = 0.8
		$Pivot/chocuf/AnimationPlayer.play(emote)
	
	#move character
	velocity = target_velocity
	move_and_slide()

func hpChange(dif: int):
	hp += dif
	if hp>mhp:
		hp = mhp
	elif hp<0:
		hp = 0

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

func _on_hurtplayer() -> void:
	if alive and itimer >= itime:
		itimer = 0
		#player gets hurt
		print("player HURT")
		$Pivot/chocuf/AnimationPlayer.speed_scale = 1
		$Pivot/chocuf/AnimationPlayer.play("Hurt")
		interrupted = true
		hpChange(-1)
	else: print("invulnerable")

func actionable() -> bool:
	return ["Hurt","Atk Stab","Atk Swing"].has(curAnim)

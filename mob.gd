class_name Mob
extends CharacterBody3D

#hp/mp
@export var hp = 10
@export var mp = 25
@export var mhp = 10
@export var mmp = 25
#player movement speed in m/s
@export var speed: float = 6
@export var atk_range: float = 10
@export var batkdmg: float = 1
@export var batkspd: float = 1
@export var target: Node3D = null
@export var auto_attacks: bool = true
@export var touch_attacks: bool = false
@export var size: float = 1
#time for invincibility
@export var itime = 0.8
var itimer = 0
var batimer = 0
@export var animator: AnimationPlayer
@onready var anim_state = null

func hpChange(dif: float, trigger_invi: bool = false):
	hp += dif
	if hp>mhp:
		hp = mhp
	elif hp<0:
		hp = 0
	#trigger self's invincibility frames if true
	if trigger_invi:
		itimer = 0

func attack_target(damage: float) -> void:
	if target!=null and attackable(atk_range, dist_to_target()):
		target.getHurt(damage)
		print(name+"deals %s " %damage+" to "+target.name)

#a target can be attack if they are in range and have no invincibility
func attackable(arange: float, dist: float) -> bool:
	return !invincible() and dist < arange
func invincible() -> bool:
	return itimer < itime

func dist_to_target() -> float:
	if target!=null:
		var dist = position.distance_to(target.position)
		return dist
	else:
		return 0

func regular_attack(damage: float = batkdmg):
	if auto_attacks and batimer >= batkspd:
		attack_target(damage)
		batimer = 0
		if animator!=null:
			anim_state.travel("base_atk")

func getHurt(amount: float):
	hpChange(-amount)
	if animator!=null:
			anim_state.travel("hurt")

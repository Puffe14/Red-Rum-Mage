class_name Mob
extends CharacterBody3D

#hp/mp
@export var hp = 10
@export var mp = 25
@export var mhp = 10
@export var mmp = 25
#player movement speed in m/s
@export var speed = 6


func hpChange(dif: int):
	hp += dif
	if hp>mhp:
		hp = mhp
	elif hp<0:
		hp = 0

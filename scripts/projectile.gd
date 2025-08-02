extends Node3D

var velocity = Vector3.RIGHT
@export var damage = 1

func _physics_process(delta):
	position += velocity * delta
	

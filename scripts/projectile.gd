extends Node3D

var velocity = Vector3.RIGHT

func _physics_process(delta):
	position += velocity * delta
	

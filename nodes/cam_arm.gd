extends Node3D
@export var turn_speed: float = 0.1

#boolean for insert buttonpress
func bp(button: String) -> bool:
	if Input.is_action_pressed(button):
		return true
	else:
		return false

func _physics_process(delta: float) -> void:
	if bp("cam_left"):
		rotate_y(turn_speed)
	if bp("cam_right"):
		rotate_y(-turn_speed)

class_name Encounter extends Node3D

func is_over()->bool:
	return get_child_count() == 0

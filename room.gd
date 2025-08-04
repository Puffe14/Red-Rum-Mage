extends Node3D
class_name Room

@export var cleared: bool
@export var rewarded: bool
@export var type: RoomType
@export var rewards: Array[Card]

enum RoomType {Encounter, Treasure, Exit, Spawn}

func onClear() -> void:
	var rewardScreen: reward_screen = reward_screen.build(rewards)
	add_child(rewardScreen)

func _physics_process(delta: float) -> void:
	if !rewarded && cleared:
		onClear()
		rewarded = true
	if Input.is_action_pressed("test"):
		cleared = true

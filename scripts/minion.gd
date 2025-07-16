extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

signal hurtplayer
var target: Node3D


func _on_player_hit() -> void:
	print("emitted player hit")
	hurtplayer.emit()

func _on_body_detected(body: Node3D) -> void:
	if body.name == "Player":
		target = body


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var player_position = position
		
	if target != null:
		if not target.alive:
			target = null
		else:
			player_position = target.position
			look_at(player_position)
	
	#check through collisions
	for index in range(get_slide_collision_count()):
		#print("collided")
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if collision.get_collider().is_in_group("player"):
			print("bumped player")
			var mob = collision.get_collider()
			_on_player_hit()
	
	var direction = (player_position - position).normalized()
	position += direction * delta
	move_and_slide()


func _on_detect_exited(body: Node3D) -> void:
	if body.name == "Player":
		target = null


func _on_hitbox_entered(body: Area3D) -> void:
	print("In hitbox: " + body.name)
	if body.name == "Projectile":
		print("projectile hit")
		queue_free()


func _on_dmgbox_entered(body: Area3D) -> void:
	print("In dmgbox: " + body.name)
	if body.name == "Player":
		print("player hitseds")
		_on_player_hit()

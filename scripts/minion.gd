extends Mob

const JUMP_VELOCITY = 4.5
const touch = 1
@export var behaviour: Behaviour
enum Behaviour {Jumpy, Walk, Dashy, Stand}


signal hurtplayer(dealt:float)


func _on_player_hit() -> void:
	print("emitted player hit")
	hurtplayer.emit(touch)

func _on_body_detected(body: Node3D) -> void:
	if body.name == "Player":
		target = body


func _physics_process(delta: float) -> void:
	itime = 0.8
	anim_state = $AnimationStateMinion["parameters/playback"]
	scale*size
	# handle DEATH
	if hp <= 0:
		if !invincible():
			queue_free()

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		pass
		#animator.play("move loop")

	#updates invincibility
	itimer += delta
	batimer += delta

	# Handle jump.
	if is_on_floor() and !invincible():
		if behaviour == Behaviour.Jumpy:
			var anitree: AnimationTree= null
			anim_state.travel("jump")
			velocity.y = JUMP_VELOCITY
		#elif batimer>batkspd/2: #animator.curresnt_animation!="move loop" and 
			#anim_state.travel("move loop")

	# get the current target's position if not null
	var target_position = position
		
	if target != null:
		if not target.alive:
			target = null
		else:
			target_position = target.position
			look_at(target_position)
	
	#check through collisions
	for index in range(get_slide_collision_count()):
		#print("collided")
		var collision = get_slide_collision(index)
		if collision.get_collider() == null:
			continue
		if touch_attacks and collision.get_collider().is_in_group("player"):
			print("bumped player")
			var mob = collision.get_collider()
			_on_player_hit()
	#attack target if they're within range
	regular_attack()
	#move closer to target if they're not in range
	if dist_to_target() > atk_range or touch_attacks:
		var direction = (target_position - position).normalized()
		position += direction * delta
	move_and_slide()


func _on_detect_exited(body: Node3D) -> void:
	if body.name == "Player":
		target = null


func _on_hitbox_entered(body: Area3D) -> void:
	print("In hitbox: " + body.name)
	if body.name == "Projectile":
		print("projectile hit")
		#grab the projectiles damage stored in the area3Ds parent node
		var taken = body.get_parent().damage
		getHurt(taken)


func _on_dmgbox_entered(body: Area3D) -> void:
	print("In dmgbox: " + body.name)
	if body.name == "Player":
		print("player hitseds")
		_on_player_hit()


func _on_hurtplayer(dealt: float) -> void:
	pass # Replace with function body.


#for state machine tht overrides regular play
func regular_attack(damage: float = batkdmg):
	if auto_attacks and batimer >= batkspd:
		attack_target(damage)
		batimer = 0
		if anim_state!=null:
			anim_state.travel("base_atk")

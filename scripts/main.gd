extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#when the player casts a spell, creates projectile
func _on_player_cast(Projectile, direction, location, speed) -> void:
	var spawned_projectile = Projectile.instantiate()
	add_child(spawned_projectile)
	#spawned_projectile.transform = transform
	#spawned_projectile.speed = transform.basis.z * 0.5
	spawned_projectile.rotation = direction
	spawned_projectile.position = location
	spawned_projectile.velocity = direction * speed
	print("direction ", direction)
	print("velocity ", spawned_projectile.velocity)
	#spawned_projectile.velocity = direction.rotated(Vector3.UP, direction.normalized()) * speed#spawned_projectile.rotation.normalized())

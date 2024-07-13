extends PickableCharacterBody3D


func _physics_process(delta):
	if is_frozen or is_picked_up():
		return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle by state machine

	move_and_slide()

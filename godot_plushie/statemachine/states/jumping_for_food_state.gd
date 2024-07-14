extends State
class_name JumpingForFoodState


# Get the name of this state
func get_state_name() -> String:
	return "Jumping for Food"


# We're entering this state
func enter() -> void:
	animator.jumps = true


# We're exiting this state
func exit() -> void:
	animator.jumps = false


# Handle physics process.
func do_physics_process(delta : float) -> bool:
	if plushie_detector.has_food():
		# See if we're not holding one of these cookies
		for food : PickableRigidBody3D in plushie_detector.get_food():
			if not food.is_picked_up():
				# Make plushie eat
				animator.eat = true
				state_machine.happiness = min(1.0, state_machine.happiness + 0.2)
				state_machine.hunger = max(0.0, state_machine.hunger - 0.2)

				# Despawn cookie
				food.queue_free()

				# Go back to idle state, eat animation will complete
				state_machine.state = get_state("IdleState")
				return false
			else:
				var direction : Vector3 = global_position.direction_to(food.global_position)
				direction.y = 0.0
				plushie.global_transform = global_transform.looking_at(global_position + direction, Vector3.UP, true)
	else:
		# We teased our pet by taking away the cookie, makes it sad
		state_machine.happiness = max(0.0, state_machine.happiness - 0.1)

		state_machine.state = get_state("IdleState")
		return false

	# Do our normal logic first
	super(delta)

	return true

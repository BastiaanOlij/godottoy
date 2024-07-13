extends State
class_name JumpingForFoodState


# Get the name of this state
func get_state_name() -> String:
	return "Jumping for Food"


# We're entering this state
func enter(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.jumps = true


# We're exiting this state
func exit(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.jumps = false


# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	var food_detector : Area3D = plushie.get_node("FoodDetector")
	if food_detector.has_overlapping_bodies():
		# See if we're not holding one of these cookies
		for body in food_detector.get_overlapping_bodies():
			if body is PickableRigidBody3D:
				var food : PickableRigidBody3D = body
				if not food.is_picked_up():
					# Make plushie eat
					var animator : PlushieAnimator = plushie.get_node("Plushie")
					animator.eat = true

					# Despawn cookie
					food.queue_free()

					# Go back to idle state, eat animation will complete
					state_machine.state = get_node("../IdleState")
					return false
	else:
		# We teased our pet by taking away the cookie, makes it sad
		state_machine.happiness = max(0.0, state_machine.happiness - 0.1)

		state_machine.state = get_node("../IdleState")
		return false

	# Do our normal logic first
	super(plushie, delta)

	return true

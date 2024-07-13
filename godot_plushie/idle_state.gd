extends State
class_name IdleState


# Get the name of this state
func get_state_name() -> String:
	return "Idle"


# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	var food_detector : Area3D = plushie.get_node("FoodDetector")
	if food_detector.has_overlapping_bodies():
		state_machine.state = get_node("../JumpingForFoodState")
		return false

	if state_machine.happiness < 0.3:
		# TODO go to sad state, should also check other markers!
		pass

	# Do our normal logic first
	super(plushie, delta)

	# Add logic: if on ground, but not standing up, get up
	# if on ground, and standing up, do random stuff

	return true

extends State
class_name PickedUpState

# Get the name of this state
func get_state_name() -> String:
	return "Picked Up"


# We're entering this state
func enter() -> void:
	animator.picked_up = true


# We're exiting this state
func exit() -> void:
	animator.picked_up = false


# Handle physics process.
@warning_ignore("unused_parameter")
func do_physics_process(delta : float) -> bool:
	plushie.velocity = Vector3()

	return false

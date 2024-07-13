extends State
class_name PickedUpState

# Get the name of this state
func get_state_name() -> String:
	return "Picked Up"


# We're entering this state
func enter(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.picked_up = true


# We're exiting this state
func exit(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.picked_up = false


# Handle physics process.
@warning_ignore("unused_parameter")
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	plushie.velocity = Vector3()

	return false

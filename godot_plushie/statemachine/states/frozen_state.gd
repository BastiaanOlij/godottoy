extends State
class_name FrozenState


# Get the name of this state
func get_state_name() -> String:
	return "Frozen"


# We're entering this state
func enter() -> void:
	plushie.visible = false


# We're exiting this state
func exit() -> void:
	plushie.visible = true


# Handle physics process.
@warning_ignore("unused_parameter")
func do_physics_process(delta : float) -> bool:
	plushie.velocity = Vector3()

	return false

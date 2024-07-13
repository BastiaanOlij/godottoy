extends State
class_name FrozenState


# Get the name of this state
func get_state_name() -> String:
	return "Frozen"


# We're entering this state
func enter(plushie : GodotPlushie) -> void:
	plushie.visible = false


# We're exiting this state
func exit(plushie : GodotPlushie) -> void:
	plushie.visible = true


# Handle physics process.
@warning_ignore("unused_parameter")
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	plushie.velocity = Vector3()

	return false

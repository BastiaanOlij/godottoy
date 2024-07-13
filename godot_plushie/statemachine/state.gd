extends Node3D
class_name State

@onready var state_machine : StateMachine = get_parent()


# Get the name of this state
func get_state_name() -> String:
	return "Unknown"


# We're entering this state
@warning_ignore("unused_parameter")
func enter(plushie : GodotPlushie) -> void:
	pass


# We're exiting this state
@warning_ignore("unused_parameter")
func exit(plushie : GodotPlushie) -> void:
	pass


# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	# Add the gravity.
	if not plushie.is_on_floor():
		plushie.velocity += plushie.get_gravity() * delta

	return true


# Handle animation finished
@warning_ignore("unused_parameter")
func on_animation_finished(plushie : GodotPlushie, anim_name) -> void:
	pass


# Return some text for debugging
func get_debug_text() -> String:
	return ""

extends State
class_name IdleState


# Get the name of this state
func get_state_name() -> String:
	return "Idle"


# We're entering this state
func enter(plushie : GodotPlushie) -> void:
	var animation_player : AnimationPlayer = plushie.get_node("AnimationPlayer")
	animation_player.play("Idle")


# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	# Do our normal logic first
	super(plushie, delta)

	# Add logic: if on ground, but not standing up, get up
	# if on ground, and standing up, do random stuff

	return true

extends State
class_name FallingState


var fall_duration : float = 0.0


# Get the name of this state
func get_state_name() -> String:
	return "Falling"


# We're entering this state
func enter() -> void:
	animator.picked_up = true

	fall_duration = 0.0


# We're exiting this state
func exit() -> void:
	animator.picked_up = false


# Handle physics process.
func do_physics_process(delta : float) -> bool:
	fall_duration += delta
	if fall_duration > 0.5 and plushie.is_on_floor():
		state_machine.state = get_state("IdleState")
		return false

	# Rotate our plushie upright
	var plushie_basis = plushie.global_transform.basis
	var plushie_up = plushie_basis.y.normalized()
	var dot = Vector3.UP.dot(plushie_up)
	if dot < 0.999:
		var cross = Vector3.UP.cross(plushie_up).normalized()
		var cos_rad = acos(dot)

		plushie.global_transform.basis = plushie_basis.rotated(cross, -cos_rad * delta * 7.0)

	# Do our normal logic first
	super(delta)

	return true

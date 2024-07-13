extends State
class_name FallingState


var fall_duration : float = 0.0


# Get the name of this state
func get_state_name() -> String:
	return "Falling"


# We're entering this state
func enter(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.picked_up = true

	fall_duration = 0.0


# We're exiting this state
func exit(plushie : GodotPlushie) -> void:
	var animator : PlushieAnimator = plushie.get_node("Plushie")
	animator.picked_up = false


var debug_text = ""

func get_debug_text() -> String:
	return debug_text

# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	debug_text = ""

	fall_duration += delta
	if fall_duration > 0.5 and plushie.is_on_floor():
		state_machine.state = get_node("../IdleState")
		return false

	# Rotate our plushie upright
	var plushie_basis = plushie.global_transform.basis
	var plushie_up = plushie_basis.y.normalized()
	var dot = Vector3.UP.dot(plushie_up)
	# debug_text = "Dot %0.2f" % [ dot ]
	if dot < 0.999:
		var cross = Vector3.UP.cross(plushie_up).normalized()
		var cos_rad = acos(dot)
		# debug_text += "\nCross %0.2f, %0.2f, %0.2f, cos: %0.2f" % [ cross.x, cross.y, cross.z, rad_to_deg(cos_rad) ]

		plushie.global_transform.basis = plushie_basis.rotated(cross, -cos_rad * delta * 7.0)

	# Do our normal logic first
	super(plushie, delta)

	return true

extends State
class_name MoveToState


@export var target_location : Vector3 = Vector3()
@export var movement_speed : float = 0.1
@export var stamina_decrease_speed : float = 0.1

## Get the name of this state
func get_state_name() -> String:
	return "Move to"


## We're entering this state
func enter() -> void:
	navigation_agent.target_position = target_location


## We're exiting this state
func exit() -> void:
	# Stop our walking animation
	animator.locomotion = Vector2(0.0, 0.0)

	# Make sure we ignore any path updates
	plushie.can_pathfind_navigate = false

	# Reset our velocity
	plushie.velocity = Vector3()

	# TODO make sure we cancel our navigation


## Handle physics process.
func do_physics_process(delta : float) -> bool:
	if do_basic_state_checks():
		return false

	if navigation_agent.is_navigation_finished():
		state_machine.state = get_state("IdleState")
		return false

	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	if (global_position - next_path_position).length() > 0.001:
		# Move to this location
		plushie.can_pathfind_navigate = true

		var direction: Vector3 = global_position.direction_to(next_path_position)
		var new_velocity: Vector3 = direction * movement_speed
		if navigation_agent.avoidance_enabled:
			# This will assign plushie.velocity on a callback, possibly in a follow up frame
			navigation_agent.velocity = new_velocity
		else:
			plushie.velocity = new_velocity

		# Face plushie in the right direction.
		direction.y = 0.0
		plushie.global_transform = global_transform.looking_at(global_position + direction, Vector3.UP, true)

		# Check if we would fall down.
		var raycast : Dictionary = do_raycast($From.global_position, $To.global_position)
		if raycast.is_empty():
			# We're about to fall off the edge, stop moving
			state_machine.state = get_state("IdleState")
			return false

		# Make plushie walk.
		animator.locomotion = Vector2(0.0, 0.5)

		# Decrease stamina
		state_machine.stamina = max(0.0, state_machine.stamina - delta * stamina_decrease_speed)
	else:
		# Standing still
		plushie.can_pathfind_navigate = false
		plushie.velocity = Vector3()
		animator.locomotion = Vector2(0.0, 0.0)

	super(delta)

	return true

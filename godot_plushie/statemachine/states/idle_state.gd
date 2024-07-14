extends State
class_name IdleState


var idle_timeout : float = 0.0


## Get the name of this state
func get_state_name() -> String:
	return "Idle"


## We're entering this state
func enter() -> void:
	idle_timeout = randf_range(0.1, 2.0)


## Handle physics process.
func do_physics_process(delta : float) -> bool:
	if do_basic_state_checks():
		return false

	# Check if our idle time has finished
	idle_timeout -= delta
	if idle_timeout < 0.0:
		var move_to_state : MoveToState = get_state("MoveToState")
		move_to_state.target_location = get_random_navigation_point()
		state_machine.state = move_to_state
		return false

	# Do our normal logic first
	super(delta)

	# Add logic: if on ground, but not standing up, get up
	# if on ground, and standing up, do random stuff

	return true

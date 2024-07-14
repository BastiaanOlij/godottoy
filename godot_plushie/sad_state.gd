extends State
class_name SadState

@export var happy_increase_speed : float = 0.1


# Get the name of this state
func get_state_name() -> String:
	return "Sad"


# We're entering this state
func enter() -> void:
	animator.cry = true


# We're exiting this state
func exit() -> void:
	animator.cry = false


## Handle physics process.
func do_physics_process(delta : float) -> bool:
	# need to do this differently, need to find interactions for user to make pet happy
	# for now, we increase happiness
	state_machine.happiness = min(1.0, state_machine.happiness + delta * happy_increase_speed)
	if state_machine.happiness == 1.0:
		state_machine.state = get_state("IdleState")
		return false

	return false

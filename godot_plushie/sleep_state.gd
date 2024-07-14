extends State
class_name SleepState

@export var stamina_increase_speed : float = 0.1

# Get the name of this state
func get_state_name() -> String:
	return "Sleep"


# We're entering this state
func enter() -> void:
	animator.sleep = true
	$GPUParticles3D.emitting = true


# We're exiting this state
func exit() -> void:
	animator.sleep = false
	$GPUParticles3D.emitting = false


## Handle physics process.
func do_physics_process(delta : float) -> bool:
	# need to do this differently, need to find interactions for user to make pet happy
	# for now, we increase happiness
	state_machine.stamina = min(1.0, state_machine.stamina + delta * stamina_increase_speed)
	if state_machine.stamina == 1.0:
		state_machine.state = get_state("IdleState")
		return false

	return false

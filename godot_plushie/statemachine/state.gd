extends Node3D
class_name State

var state_machine : StateMachine
var plushie : GodotPlushie
var animator : PlushieAnimator
var navigation_agent : NavigationAgent3D
var plushie_detector : PlushieDetector

## Get the name of this state
func get_state_name() -> String:
	return "Unknown"


## Helper function to get another state from our state machine.
func get_state(state_name : String) -> State:
	return state_machine.get_state(state_name)


## We're entering this state
func enter() -> void:
	pass


## We're exiting this state
func exit() -> void:
	pass


## Handle physics process.
func do_physics_process(delta : float) -> bool:
	# Add the gravity.
	if not plushie.is_on_floor():
		plushie.velocity += plushie.get_gravity() * delta

	return true


## Handle animation finished
@warning_ignore("unused_parameter")
func on_animation_finished(anim_name) -> void:
	pass


##############################
# Some helpers

## Do our basic state interuption checks.
## Returns true if we handled a state change.
func do_basic_state_checks() -> bool:
	if plushie_detector.has_food():
		state_machine.state = get_state("JumpingForFoodState")
		return true

	# Check if we are too unhappy, if so switch to sad state
	if state_machine.happiness < 0.3:
		state_machine.state = get_state("SadState")
		return true

	# Check if we are too tired, if so switch to sleeping state
	if state_machine.stamina < 0.2:
		state_machine.state = get_state("SleepState")
		return true

	return false


func do_raycast(from : Vector3, to : Vector3) -> Dictionary:
	var state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var parameters : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	return state.intersect_ray(parameters)


## Attempt to get the navmesh reference and get a random point from it.
func get_random_navigation_point() -> Vector3:
	var random_point : Vector3 = Vector3()
	var navmesh_node = get_tree().get_nodes_in_group("navmesh_regions")
	if not navmesh_node.is_empty():
		var navmesh_map_rid:RID = (navmesh_node[0] as NavigationRegion3D).get_navigation_map()
		random_point = NavigationServer3D.map_get_random_point(navmesh_map_rid, 1, false)

	return random_point

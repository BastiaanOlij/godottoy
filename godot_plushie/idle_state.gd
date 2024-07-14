extends State
class_name IdleState

var navmesh_map_rid:RID

# Get the name of this state
func get_state_name() -> String:
	return "Idle"

# We're entering this state
@warning_ignore("unused_parameter")
func enter(plushie : GodotPlushie) -> void:
	## Attempt to get the navmesh reference and get a random point from it.
	var navmesh_node = get_tree().get_nodes_in_group("navmesh_regions")
	if not navmesh_node.is_empty():
		navmesh_map_rid = (navmesh_node[0] as NavigationRegion3D).get_navigation_map()
		print("Navmesh rid acquired")
		await get_tree().process_frame
		var random_point = NavigationServer3D.map_get_random_point(navmesh_map_rid, 1, false)
		print("Random point is ", random_point)

		#state_machine.plushie.set_navigation_target(random_point)

# Handle physics process.
func do_physics_process(plushie : GodotPlushie, delta : float) -> bool:
	var food_detector : Area3D = plushie.get_node("FoodDetector")
	if food_detector.has_overlapping_bodies():
		state_machine.state = get_node("../JumpingForFoodState")
		return false

	if state_machine.happiness < 0.3:
		# TODO go to sad state, should also check other markers!
		pass

	# Do our normal logic first
	super(plushie, delta)

	# Add logic: if on ground, but not standing up, get up
	# if on ground, and standing up, do random stuff

	return true

extends Node3D
class_name StateMachine

@export var plushie : GodotPlushie
@export var animator : PlushieAnimator
@export var navigation_agent : NavigationAgent3D
@export var plushie_detector : PlushieDetector

@export_range(0.0, 1.0, 0.1) var stamina : float = 1.0
@export_range(0.0, 1.0, 0.1) var hunger : float = 0.0
@export_range(0.0, 1.0, 0.1) var happiness : float = 1.0

@export var hunger_increase_speed : float = 0.1

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var state : State:
	set(value):
		if state and is_inside_tree():
			# need to exit current state
			state.exit()

		state = value
		if state and is_inside_tree():
			# init our new state
			state.enter()


func get_state(state_name : String) -> State:
	var state : State = get_node_or_null(state_name)
	return state


# Called when the node enters the scene tree for the first time.
func _ready():
	# Update all our states with links to our nodes we need.
	for child in get_children():
		if child is State:
			var state : State = child
			state.state_machine = self
			state.plushie = plushie
			state.animator = animator
			state.navigation_agent = navigation_agent
			state.plushie_detector = plushie_detector

	# Set default label text
	if state:
		$StateLabel.text = state.get_state_name()
		state.enter()
	else:
		$StateLabel.text = "No state"


func do_physics_process(delta : float) -> bool:
	# Increase hunger
	hunger = min(1.0, hunger + delta * hunger_increase_speed)

	# Just for debugging
	var text : String
	if state:
		text = state.get_state_name()
	else:
		text = "No state"

	text += "\nStamina %0.1f\nHunger %0.1f\nHappiness %0.1f" % [ stamina, hunger, happiness ]

	$StateLabel.text = text

	var head_tracker : XRPositionalTracker = XRServer.get_tracker("head")
	if head_tracker:
		var pose : XRPose = head_tracker.get_pose("default")
		var pos : Vector3 = XRServer.world_origin * pose.get_adjusted_transform().origin
		pos.y = $StateLabel.global_position.y
		$StateLabel.look_at(pos, Vector3.UP, true)

	# Show how happy we are...
	if happiness > 0.7:
		animator.using_texture = PlushieAnimator.PlushieTexture.HAPPY
	elif happiness > 0.3:
		animator.using_texture = PlushieAnimator.PlushieTexture.REGULAR
	else:
		animator.using_texture = PlushieAnimator.PlushieTexture.SAD

	if state:
		return state.do_physics_process(delta)
	else:
		return false


func _on_animation_finished(anim_name):
	if state:
		state.on_animation_finished(anim_name)

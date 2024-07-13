extends Node3D
class_name StateMachine

@onready var plushie : GodotPlushie = get_parent()

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var state : State:
	set(value):
		if is_inside_tree():
			# need to exit current state
			state.exit(plushie)

		state = value
		if state and is_inside_tree():
			# init our new state
			state.enter(plushie)



# Called when the node enters the scene tree for the first time.
func _ready():
	if state:
		$StateLabel.text = state.get_state_name()
		state.enter(plushie)
	else:
		$StateLabel.text = "No state"


func do_physics_process(delta : float) -> bool:
	var text : String
	if state:
		text = state.get_state_name()
	else:
		text = "No state"

	if plushie.is_on_floor():
		text += "\nIs on floor"
	else:
		text += "\nIs not on floor"

	if state:
		var debug_text = state.get_debug_text()
		if not debug_text.is_empty():
			text += "\n" + debug_text

	$StateLabel.text = text

	if state:
		return state.do_physics_process(plushie, delta)
	else:
		return false


func _on_animation_finished(anim_name):
	if state:
		state.on_animation_finished(plushie, anim_name)

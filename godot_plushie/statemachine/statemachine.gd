extends Node
class_name StateMachine

# Path to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var state : State

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

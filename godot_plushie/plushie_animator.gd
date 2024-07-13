extends Node3D
class_name PlushieAnimator

@onready var animation_tree = %AnimationTree

@export var sit:bool = false
@export var picked_up:bool = false
@export var sleep:bool = false
@export var jumps:bool = false
@export var cry:bool = false

## This works with Y being forwards/backwards and X 0 is arms normal, X 1 being arms forward.
## Y 0.5 is walk, Y 1.0 is run.
@export var locomotion:Vector2 = Vector2.ZERO:
	set(v):
		locomotion = v
		animation_tree.set("parameters/Locomotion/blend_position", v)

## These auto-set themselves to false afterwards so they can be repeated.
@export var eat:bool = false:
	set(v):
		eat = v
		# await get_tree().create_timer(0.05).timeout
		# eat = false
@export var yes:bool = false:
	set(v):
		yes = v
		await get_tree().create_timer(0.02).timeout
		yes = false
@export var no:bool = false:
	set(v):
		no = v
		await get_tree().create_timer(0.02).timeout
		no = false


func _on_animation_finished(anim_name):
	if anim_name == "Eat":
		eat = false

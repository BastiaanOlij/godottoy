extends Node3D
class_name PlushieAnimator

@onready var animation_tree = %AnimationTree

enum PlushieTexture{
	REGULAR = 0,
	HAPPY = 1,
	SAD = 2
}

@onready var plush_material = load("res://assets/gltf/PlushieCharacter/Material_Godot_Plushie.tres")
const PLUSH_HAPPY_BASECOLOR = preload("res://assets/gltf/PlushieCharacter/plush_happy_basecolor.png")
const PLUSH_BASECOLOR = preload("res://assets/gltf/PlushieCharacter/plush_basecolor.png")
const PLUSH_SAD_BASECOLOR = preload("res://assets/gltf/PlushieCharacter/plush_sad_basecolor.png")

@export var using_texture:PlushieTexture = PlushieTexture.REGULAR:
	set(v):
		if v != using_texture and is_instance_valid(plush_material):
			using_texture = v
			match v:
				PlushieTexture.REGULAR:
					plush_material.albedo_texture = PLUSH_BASECOLOR
				PlushieTexture.HAPPY:
					plush_material.albedo_texture = PLUSH_HAPPY_BASECOLOR
				PlushieTexture.SAD:
					plush_material.albedo_texture = PLUSH_SAD_BASECOLOR

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
@export var eat:bool = false

@export var yes:bool = false:
	set(v):
		yes = v
		await get_tree().create_timer(0.03).timeout
		yes = false
@export var no:bool = false:
	set(v):
		no = v
		await get_tree().create_timer(0.03).timeout
		no = false

func _on_animation_tree_animation_started(anim_name):
	if anim_name == "Eat":
		eat = false

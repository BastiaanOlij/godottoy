extends RigidBody3D
class_name PickableObject3D

@export var snap_on_pickup = true

@onready var highlight_material : Material = preload("res://materials/highlight_material.tres")

var is_frozen : bool = true
var picked_up_by : Area3D
var closest_areas : Array

var original_parent : Node3D
var tween : Tween

# Unfreeze is called by our main script once our global mesh is setup.
func unfreeze():
	is_frozen = false
	_update_freeze()


func is_picked_up():
	if picked_up_by:
		return true

	return false


func _update_freeze():
	freeze = is_frozen || is_picked_up()


# Called when we become the closest body for a grab detector
func add_is_closest(closest_to : Area3D):
	if not closest_areas.has(closest_to):
		closest_areas.push_back(closest_to)
		print("is closest!")

	_update_highlight()


# Called when we are no longer the closest body for a grab detector
func remove_is_closest(closest_to : Area3D):
	if closest_areas.has(closest_to):
		closest_areas.erase(closest_to)

	_update_highlight()


func _update_highlight():
	if not picked_up_by and not closest_areas.is_empty():
		for child in get_children():
			if child is MeshInstance3D:
				var mesh_instance : MeshInstance3D = child
				mesh_instance.material_overlay = highlight_material
	else:
		for child in get_children():
			if child is MeshInstance3D:
				var mesh_instance : MeshInstance3D = child
				mesh_instance.material_overlay = null


func pick_up(pick_up_by):
	if is_frozen:
		return

	if picked_up_by:
		if picked_up_by == pick_up_by:
			return

		let_go()

	# Remember where we were
	original_parent = get_parent()
	var current_transform = global_transform

	# Remove from our original parent
	original_parent.remove_child(self)

	# Now pick up
	picked_up_by = pick_up_by
	picked_up_by.add_child(self)
	global_transform = current_transform
	_update_freeze()

	# Kill any existing tween
	if tween:
		tween.kill()
		tween = null

	if snap_on_pickup:
		# And tween
		tween = create_tween()
		tween.tween_property(self, "transform", Transform3D(), 0.1)

func let_go():
	if not picked_up_by:
		return

	# Cancel any tween
	if tween:
		tween.kill()
		tween = null

	var current_transform = global_transform

	# Remove from picked up
	picked_up_by.remove_child(self)
	picked_up_by = null

	original_parent.add_child(self)
	global_transform = current_transform

	_update_freeze()

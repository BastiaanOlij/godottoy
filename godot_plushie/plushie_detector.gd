extends Area3D
class_name PlushieDetector


func has_food() -> bool:
	for collision_object : CollisionObject3D in get_overlapping_bodies():
		if collision_object.collision_layer & 2:
			return true
	return false


func get_food() -> Array[PickableRigidBody3D]:
	var result : Array[PickableRigidBody3D]
	for collision_object : CollisionObject3D in get_overlapping_bodies():
		if collision_object is PickableRigidBody3D and collision_object.collision_layer & 2:
			var food : PickableRigidBody3D = collision_object
			if food:
				result.push_back(food)

	return result

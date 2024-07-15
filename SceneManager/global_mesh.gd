extends StaticBody3D
class_name GlobalMesh

@export var material : Material

func setup_scene(entity: OpenXRFbSpatialEntity) -> void:
	var collision_shape = entity.create_collision_shape()
	if collision_shape:
		add_child(collision_shape)

	var mesh_instance = entity.create_mesh_instance()
	if mesh_instance:
		add_child(mesh_instance)

		mesh_instance.material_override = material

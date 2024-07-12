extends Node3D

@onready var scene_manager: OpenXRFbSceneManager = $XROrigin3D/OpenXRFbSceneManager

func _on_scene_data_missing():
	scene_manager.request_scene_capture()


func _on_scene_capture_completed(success):
	if success == false:
		return

	# Recreate scene anchors since the user may have changed them.
	if scene_manager.are_scene_anchors_created():
		scene_manager.remove_scene_anchors()
		scene_manager.create_scene_anchors()

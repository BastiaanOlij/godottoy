extends XROrigin3D

@export var enabled : bool = true:
	set(value):
		enabled = value
		if is_inside_tree():
			_update_enabled()

func _update_enabled():
	$LeftHandController/GrabDetector.enabled = enabled
	$RightHandController/GrabDetector.enabled = enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_enabled()

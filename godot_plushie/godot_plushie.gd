extends PickableCharacterBody3D
class_name GodotPlushie

@export var movement_speed:float = 5.0
@onready var navigation_agent_3d = %NavigationAgent3D
@export var can_pathfind_navigate:bool = true
func _ready():
	navigation_agent_3d.velocity_computed.connect(_on_navigation_velocity_computed)

func set_navigation_target(navigation_target: Vector3):
	navigation_agent_3d.set_target_position(navigation_target)

# Unfreeze is called by our main script once our global mesh is setup.
func unfreeze():
	print("Unfreeze plushie")

	super()

	$StateMachine.state = $StateMachine/FallingState


func pick_up(pick_up_by):
	print("Pickup plushie")

	if is_frozen:
		return

	super(pick_up_by)

	$StateMachine.state = $StateMachine/PickedUpState


func let_go(new_linear_velocity = Vector3()):
	print("Let go plushie")
	if not picked_up_by:
		return

	super(new_linear_velocity)

	$StateMachine.state = $StateMachine/FallingState

func _physics_process(delta):
	if can_pathfind_navigate and not navigation_agent_3d.is_navigation_finished():
		var next_path_position: Vector3 = navigation_agent_3d.get_next_path_position()
		var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed
		if navigation_agent_3d.avoidance_enabled:
			navigation_agent_3d.velocity = new_velocity
		else:
			_on_navigation_velocity_computed(new_velocity)

	# Handle by state machine
	if $StateMachine.do_physics_process(delta):
		move_and_slide()

func _on_navigation_velocity_computed(safe_velocity: Vector3):
	if can_pathfind_navigate:
		velocity = safe_velocity

extends PickableCharacterBody3D
class_name GodotPlushie

@onready var navigation_agent_3d = %NavigationAgent3D
@export var can_pathfind_navigate : bool = false

func _ready():
	navigation_agent_3d.velocity_computed.connect(_on_navigation_velocity_computed)


# Unfreeze is called by our main script once our global mesh is setup.
func unfreeze():
	super()

	$StateMachine.state = $StateMachine/FallingState


func pick_up(pick_up_by):
	if is_frozen:
		return

	super(pick_up_by)

	$StateMachine.state = $StateMachine/PickedUpState


func let_go(new_linear_velocity = Vector3()):
	if not picked_up_by:
		return

	super(new_linear_velocity)

	$StateMachine.state = $StateMachine/FallingState


func _physics_process(delta):
	# Handle by state machine
	if $StateMachine.do_physics_process(delta):
		move_and_slide()


func _on_navigation_velocity_computed(safe_velocity: Vector3):
	if can_pathfind_navigate:
		velocity = safe_velocity

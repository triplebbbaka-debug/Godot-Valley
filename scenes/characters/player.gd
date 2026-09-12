extends CharacterBody2D
#Player Script

#Establishes direction
var direction: Vector2

var speed := 50
@onready var move_state_machine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
func _physics_process(_delta: float) -> void:
	get_basic_input()
	move()
	animate()
#Handles movement

func get_basic_input():
	if Input.is_action_just_pressed("action"):
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
func animate():
	if direction:
		var direction_animation = Vector2(round(direction.x), round(direction.y))
		move_state_machine.travel('Walk')
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", direction_animation)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			var animation_name: String = ("parameters/ToolStateMachine/"+ animation +"/blend_position")
			$Animation/AnimationTree.set(animation_name, direction_animation)
	else:
		move_state_machine.travel('Idle')
func tool_use_emit():
	print('tool')

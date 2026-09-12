extends CharacterBody2D
#Player Script

#Establishes direction
var direction: Vector2

var speed := 50

func _physics_process(_delta: float) -> void:
	move()
	animate()
#Handles movement
func move():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()

func animate():
	if direction.x == 1:
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.RIGHT)
	elif direction.x == -1:
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.LEFT)
	elif direction.y == -1:
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.UP)
	elif direction.y == 1:
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.DOWN)
func tool_use_emit():
	print('tool')

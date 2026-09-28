extends Machine

func _ready() -> void:
	start_fishing()
	
	
func _process(_delta: float) -> void:
	var progress = 100 * (1 - ($Timer.time_left /$Timer.wait_time))
	$Control/TextureProgressBar.value = progress
func _on_timer_timeout() -> void:
	start_fishing()

func start_fishing():
	$AnimatedSprite2D.play("left")
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D.play("left_idle")
	$Timer.start()

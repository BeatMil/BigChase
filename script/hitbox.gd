extends Node2D

export var ACTIVE_FRAME = 3.0

func _ready():
	$Timer.wait_time = ACTIVE_FRAME / 60
	$Timer.start()

func _on_Timer_timeout():
	queue_free()

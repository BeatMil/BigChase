extends Node2D

var beat = 10
func _ready():
	# lerp(velocity.x, 0, friction)
	pass

func _process(delta):
	beat = lerp(beat, 0, 0.2)
	if beat <= 0.001:
		print("Ehhh?")
		get_tree().quit()
	else:
		print(beat)

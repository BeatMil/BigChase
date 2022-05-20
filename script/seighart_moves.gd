# seighart_moves.gd
extends Node2D


# hitbox
onready var hitbox01 = load("res://hitboxes/hitbox01.tscn")


func attack01():
	var offset
	if $"../Sprite".flip_h == true:
		offset = Vector2(-150,0)
	elif $"../Sprite".flip_h == false:
		offset = Vector2(150,0)
	var hitbox01_real = hitbox01.instance()
	hitbox01_real.position += offset
	add_child(hitbox01_real) # spawn hitbox

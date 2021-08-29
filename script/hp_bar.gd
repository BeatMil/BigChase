extends Node2D

export var hp = 20
var max_hp

# Colors
onready var green = load("res://players/stylebox/green.tres")
onready var yellow = load("res://players/stylebox/yellow.tres")
onready var red = load("res://players/stylebox/red.tres")

func _ready():
	var ok = $"../char".connect("stunned01", self, "_on_char_stunned01")
	print("connect hp_bar to char status: ", ok)
	max_hp = hp
	to_yellow()
	update_bar()


func set_hp(amount : int):
	hp = amount
	update_bar()


func decrease_hp(amount : int):
	hp -= amount
	update_bar()


func increase_hp(amount: int):
	hp += amount
	update_bar()


func update_bar():
	if (float(hp) / max_hp) >= 0.8:
		to_green()
	elif (float(hp) / max_hp) <= 0.3:
		to_red()
	elif (float(hp) / max_hp) < 0.8:
		to_yellow()
	$ProgressBar.value = hp


func to_green():
	$ProgressBar.set("custom_styles/fg", green)


func to_yellow():
	$ProgressBar.set("custom_styles/fg", yellow)


func to_red():
	$ProgressBar.set("custom_styles/fg", red)


func _on_char_stunned01():
	decrease_hp(1)

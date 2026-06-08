extends Node2D

@onready var player = preload("res://scenes/player/player.tscn")

func _ready():
	# Instantiate player at center of screen
	var player_instance = player.instantiate()
	player_instance.position = Vector2(640, 360)  # Center of 1280x720 screen
	add_child(player_instance)

extends Node2D

const GRASS_EFFECT = preload("res://scenes/effects/grass_effect.tscn")

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.area_entered.connect(_on_area_2d_area_entered)
	pass # Replace with function body.


func _on_area_2d_area_entered(_other_area_2d: Area2D) -> void:
	var grass_effect_instance = GRASS_EFFECT.instantiate()
	grass_effect_instance.global_position = global_position
	get_tree().current_scene.add_child(grass_effect_instance)
	queue_free()
	

extends Node2D

#const GRASS_EFFECT = preload("res://art/effects/grass/grass_effect.tscn")
@export var GRASS_EFFECT: PackedScene

@onready var hurtbox: Hurtbox = $Hurtbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)


func _on_hurt(other_hitbox: Hitbox) -> void:
	var grass_effect_instance = GRASS_EFFECT.instantiate()
	grass_effect_instance.global_position = global_position
	get_tree().current_scene.add_child(grass_effect_instance)
	queue_free()
	

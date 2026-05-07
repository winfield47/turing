extends CharacterBody2D

const SPEED = 50

@export var aggro_range: = 128

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var ray_cast_2d: RayCast2D = $RayCast2D

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"Idle": idle_state(delta)
		"Chase": chase_state(delta)

func idle_state(_delta: float) -> void:
	pass
	
func chase_state(_delta: float) -> void:
	var player = get_player()
	if player is Player:
		velocity = global_position.direction_to(player.global_position) * SPEED
		sprite_2d.scale.x = sign(velocity.x)
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")
	
func player_in_range() -> bool:
	var result = false
	var player: = get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < aggro_range:
			result = true
	return result

func player_is_visible() -> bool:
	if not player_in_range(): return false
	var player: = get_player()
	if player is not Player: return false
	ray_cast_2d.target_position = player.global_position - global_position
	var _player_is_visible: = not ray_cast_2d.is_colliding()
	return _player_is_visible

extends CharacterBody2D

const HIT_EFFECT = preload("uid://cnox5xb0esdfl")
const DEATH_EFFECT = preload("uid://cla3a7y75aeu7")

const SPEED = 50
const FRICTION = 500

@export var aggro_range: = 128
@export var min_range: = 4
@export var stats: Stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var center: Marker2D = $Center

func _ready() -> void:
	stats = stats.duplicate()
	hurtbox.hurt.connect(take_hit.call_deferred)
	stats.no_health.connect(die)

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState": idle_state(delta)
		"ChaseState": chase_state(delta)
		"HitState": hit_state(delta)

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

func hit_state(_delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * _delta)
	move_and_slide()
	
func die() -> void:
	var death_effect = DEATH_EFFECT.instantiate()
	get_tree().current_scene.add_child(death_effect)
	death_effect.global_position = center.global_position
	queue_free()
	
func take_hit(other_hitbox: Hitbox) -> void:
	var hit_effect = HIT_EFFECT.instantiate()
	get_tree().current_scene.add_child(hit_effect)
	hit_effect.global_position = center.global_position
	stats.health -= other_hitbox.damage
	velocity = other_hitbox.knockback_direction * other_hitbox.knockback_amount
	playback.start("HitState")
	
func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")
	
func player_in_range() -> bool:
	var result = false
	var player: = get_player()
	if player is Player:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player < aggro_range and distance_to_player > min_range:
			result = true
	return result

func player_is_visible() -> bool:
	if not player_in_range(): return false
	var player: = get_player()
	if player is not Player: return false
	ray_cast_2d.target_position = player.global_position - global_position
	var _player_is_visible: = not ray_cast_2d.is_colliding()
	return _player_is_visible

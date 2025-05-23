extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5
@onready var player = get_tree().get_first_node_in_group("player")

var velocity = Vector2.ZERO
var randomness = Vector2.RIGHT.rotated(randf_range(0, TAU)) * .65


func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	
	#var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))


func move(character_body: CharacterBody2D):
	if owner == player:
		character_body.velocity = velocity
	else:
		character_body.velocity = velocity + randomness
	
	character_body.move_and_slide()
	velocity = character_body.velocity

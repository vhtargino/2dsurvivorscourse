extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var velocity_component = $VelocityComponent


func _ready():
	$HurtboxComponent.hit.connect(on_hit)


func _process(_delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if velocity.x != 0:
		visuals.scale = Vector2(move_sign, 1)


func on_hit():
	$EnemyHitRandomStreamPlayerComponent2.play_random()

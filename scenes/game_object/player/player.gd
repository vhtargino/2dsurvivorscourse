extends CharacterBody2D

var horizontal_queue = []
var vertical_queue = []

var character_speed = 70

@onready var sprite = %PlayerSprite
@onready var health_component = $HealthComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var visuals: Node2D = $Visuals

var number_colliding_bodies = 0


func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(_delta: float):
	var movement_vector = get_movement_vector()
	velocity = movement_vector.normalized() * character_speed
	move_and_slide()
	
	if movement_vector.x != 0 or movement_vector.y != 0:
		sprite.play("player_walk")
	else:
		sprite.play("player_idle")

	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return Vector2(x_movement, y_movement)


#func get_movement_vector() -> Vector2:
	## Atualiza filas removendo teclas soltas e adicionando novas pressionadas
	#horizontal_queue = horizontal_queue.filter(Input.is_action_pressed)
	#vertical_queue = vertical_queue.filter(Input.is_action_pressed)
#
	#for action in ["move_right", "move_left"]:
		#if Input.is_action_just_pressed(action):
			#horizontal_queue.append(action)
#
	#for action in ["move_down", "move_up"]:
		#if Input.is_action_just_pressed(action):
			#vertical_queue.append(action)
#
	#if vertical_queue or horizontal_queue:
		#sprite.play("player_walk")
	#else:
		#sprite.play("player_idle")
		#
	#if horizontal_queue and horizontal_queue[-1] == "move_left":
		#sprite.flip_h = true
	#if horizontal_queue and horizontal_queue[-1] == "move_right":
		#sprite.flip_h = false
#
	## Define os valores diretamente, eliminando verificações desnecessárias
	#var x_input = 1 if horizontal_queue and horizontal_queue[-1] == "move_right" else -1 if horizontal_queue else 0
	#var y_input = 1 if vertical_queue and vertical_queue[-1] == "move_down" else -1 if vertical_queue else 0
#
	#return Vector2(x_input, y_input)


func update_health_display():
	health_bar.value = health_component.get_health_percent()


func check_deal_damage():
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1


func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	update_health_display()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if not ability_upgrade is Ability:
		return
	
	#var ability = ability_upgrade as Ability
	abilities.add_child(ability_upgrade.ability_controller_scene.instantiate())

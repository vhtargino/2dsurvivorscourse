extends CanvasLayer


func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitToMenuButton.pressed.connect(on_quit_to_menu_button_pressed)


func set_defeat():
	%TitleLabel.text = "Defeat"
	%DescriptionLabel.text = "You lost!"


func on_restart_button_pressed():
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().reload_current_scene()


func on_quit_to_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")

extends Button

onready var reset_dialog = $ConfirmReset
onready var viewport_center = get_viewport_rect().size/2	# gets half the size, which is the center

func _on_ResetButton_pressed():		# centers dialog box and makes it visible
	reset_dialog.rect_global_position = viewport_center - reset_dialog.rect_size/2
	reset_dialog.visible = true

func _on_ConfirmReset_confirmed():	# restarts the entire scene (does not initialize variaables?)
	var _resetter = get_tree().reload_current_scene()		

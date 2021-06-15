extends Button

onready var about_dialog = $AboutDialog
onready var window_center = get_viewport_rect().size/2		# gets half the size, which is the center

func _on_AboutButton_pressed():		# centers dialog box and makes it visible
	about_dialog.rect_global_position = window_center - about_dialog.rect_size/2	
	about_dialog.visible = true
	
func _on_RichTextLabel_meta_clicked(meta):		# handles hyperlinks in the document
	var _opener = OS.shell_open(meta)

extends HSlider

signal slider_id(id)		# signal that tells listening nodes its identity
signal print_read(id, value)

func _on_Slider_mouse_entered():
	emit_signal("slider_id", self)

func _on_Slider_value_changed(value):		# sends a signal to update changes box
	emit_signal("print_read", self, value)

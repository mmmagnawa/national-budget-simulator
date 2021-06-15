extends Control

signal slider_id(id)
signal print_read(id, value)

onready var slider_node = get_node("HBoxContainer/HSlider")

func _on_HSlider_mouse_entered():
	emit_signal("slider_id", slider_node)	# signals identity of HSlider


func _on_HSlider_value_changed(value):

	emit_signal("print_read", slider_node, value)	# forces update on ChangesController

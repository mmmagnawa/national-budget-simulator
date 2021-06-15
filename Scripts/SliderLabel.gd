extends Label

var percent_mode = false
onready var slider = get_parent().get_node("HSlider")

func _on_Slider_value_changed(value):	# changes value of text depending on slider value
	activate_percent_display(percent_mode, value)
		
func _on_SliderController_percent_enabled(state):	# handles switching between modes
	if state == true:
		percent_mode = true
	if state == false:
		percent_mode = false
	activate_percent_display(percent_mode, slider.value)

func activate_percent_display(state, value):	# changes text based on if percentage display is set
	match(state):
		true:
			self.text = str( stepify(value/slider.max_value*100, 0.01) ).pad_decimals(2) + '%'
		false:
			self.text = '\u20B1' + str(stepify(value, 0.01)).pad_decimals(2) + ' B'

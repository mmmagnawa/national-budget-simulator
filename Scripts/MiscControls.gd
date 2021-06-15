extends Control

onready var palette_box = get_tree().get_nodes_in_group("randomizer")[0]

#2021 values used when "Use 2021 Budget" is
export var base_values = [754.4, 242.6, 399.9, 203.1, 803.8, 810.9, 2.41, 531.5, 757.39, 0]
export var base_budget = 4506

signal enable_percentage(state)
signal enable_rotation(state)
signal fixed_palette(state)
signal baseline(value)
signal distribute

func _on_PieRotateBox_toggled(button_pressed):	# enables or diables the pie chart to rotate
	match(button_pressed):
		true:
			emit_signal("enable_rotation", true)
		false:
			emit_signal("enable_rotation", false)

func _on_PercentBox_toggled(button_pressed):	# toggle to display percentages or real values
	match(button_pressed):
		true:
			emit_signal("enable_percentage", true)
		false:
			emit_signal("enable_percentage", false)

func _on_PaletteBox_toggled(button_pressed):
	match(button_pressed):
		true:	# uses fixed color palettes handled by PieChart
			palette_box.visible = false
			emit_signal("fixed_palette", true)
		false:	# shows randomize button
			palette_box.visible = true
			
func _on_RandomizerButton_pressed():	# randomizes color palettes
	emit_signal("fixed_palette", false)

func _on_2021Button_pressed():	# switches all sliders to use 2021 values
	var sliders_list = get_tree().get_nodes_in_group("slider")
	base_values.resize(sliders_list.size())
	for i in sliders_list.size():
		match(base_values[i]):
			null:
				base_values[i] = 0	# extra sliders automatically get set to 0
		emit_signal("baseline", base_budget)
		sliders_list[i].value = base_values[i]
		emit_signal("baseline", base_budget)

func _on_DistributeButton_pressed():	# redistributes budget evenly to all sectors
	var sliders_list = get_tree().get_nodes_in_group("slider")
	var max_budget = sliders_list[0].max_value
	for slider in sliders_list:
		slider.value = max_budget/sliders_list.size()
	emit_signal("distribute")

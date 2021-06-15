extends Control

onready var sliders_array = get_tree().get_nodes_in_group("slider")
onready var sliders_count = get_tree().get_nodes_in_group("slider").size()
onready var fixed_colors = DictData.fixed_colors

var chart_node = preload("res://Scenes/Chart.tscn")
var iterated_sum = 0
var cumulative_sum = []
var values_array = []
var color_list = []

export var rotation_speed = 0.25	# default speed of pie chart rotation

signal color_changed(color_list)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	for num in sliders_array.size():
		add_child(chart_node.instance())	# adds a chart for each slider in the scene
	_on_MiscControls_fixed_palette(true)	# enables fixed colors by default
	_on_SliderController_chart_change()		# updates sliders, needed due to update order?

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rect_rotation += rotation_speed*delta	# slowly rotates the pie chart

# automatically updates chart value and starting angle
func _on_SliderController_chart_change():
	var charts_list = get_tree().get_nodes_in_group("chart")
	for slider in sliders_array:
		iterated_sum += slider.value
		cumulative_sum.append(min(iterated_sum, sliders_array[0].max_value))
		values_array.append(slider.value)
	cumulative_sum.invert()
	values_array.invert()
	for count in sliders_count:		# scales both chart values and initial angles in response
		charts_list[count].value = values_array[count]/sliders_array[0].max_value*100
		charts_list[count].radial_initial_angle = ((cumulative_sum[count] - values_array[count])/sliders_array[0].max_value)*360
		charts_list[count]._on_Slider_value_changed(0)		# calls the function by force (argument is irrelevant)
	iterated_sum = 0
	values_array.clear()
	cumulative_sum.clear()


func _on_MiscControls_enable_rotation(state):
	match(state):	# changes the rotation speed (0 or moving)
		true:
			rotation_speed = 0.25
		false:
			rotation_speed = 0


func _on_MiscControls_fixed_palette(state):		# changes color of charts
	var charts_list = get_tree().get_nodes_in_group("chart")
	fixed_colors.invert()

	var extra_colors = fixed_colors.duplicate()
	extra_colors.invert()
	
	fixed_colors.resize(charts_list.size())
	for i in fixed_colors.size():
		match(fixed_colors[i]):
			null:
				fixed_colors[i] = extra_colors[i % 9]
	fixed_colors.invert()
	color_list = []
	
	match(state):
		true:
			for i in charts_list.size():
				charts_list[i].modulate = fixed_colors[i]
				color_list.append(fixed_colors[i])
		false:
			for chart in charts_list:
				var new_color = Color(randf(), randf(), randf(), 1)
				color_list.append(new_color)
				chart.modulate = new_color
	emit_signal("color_changed", color_list)	# sends array of colors used to SliderController

func _on_MiscControls_distribute():		# updates sliders and charts properly
	_on_SliderController_chart_change()	# this function exists to force an update 

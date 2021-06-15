extends Control

onready var sliders_list = get_tree().get_nodes_in_group("slider")
onready var sliders_names = get_tree().get_nodes_in_group("slider_name")
onready var sliders_labels = get_tree().get_nodes_in_group("slider_label")
onready var names_list = DictData.abbrev_list

export var slider_half_width = 5	# controls half-thickness of slider

export var max_budget = 4506	#budget in billions
var old_budget = max_budget		# last set budget, set to max_budget at initialization

onready var budget_label = get_tree().get_nodes_in_group("budget_label")[0]
onready var budget_editor = get_tree().get_nodes_in_group("budget_editor")[0]

signal chart_change
signal percent_enabled(state)
var percent_state = false	# by default disables showing percentages

var sum = 0
var budget_distrib = 0
var this_id

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in sliders_list.size():
		sliders_list[i].max_value = max_budget
		sliders_list[i].value = max_budget/sliders_list.size()
		var _percent_signaller = self.connect("percent_enabled", sliders_labels[i], "_on_SliderController_percent_enabled")
	budget_editor.value = max_budget
	# initializes all sliders and connects percent_enabled to change this later

	# this part initializes the slider names and configures it to avoid errors
	var names_array = []
	names_array.resize( sliders_list.size() )
	for i in names_list.size():
		names_array[i] = names_list[i]

	for i in names_array.size():
		match(names_array[i]):
			null:
				names_array[i] = "N/A"
		sliders_names[i].text = str(names_array[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):	# underscore in argument means it does not get used
	for slider in sliders_list:
		sum += slider.value
	# based on an implementation at https://codepen.io/KenFalcon/full/OVKOZB
	if sum != max_budget:
		budget_distrib = (sum - max_budget)/(sliders_list.size()-1)
		for slider in sliders_list:
			if slider != this_id:	# modifies all but the "active" slider
				slider.value -= budget_distrib
		emit_signal("chart_change")
	sum = 0

func _on_Slider_slider_id(id):	# signals which is the "active" slider
	this_id = id

func _on_BudgetEditor_value_changed(value):	# updates all sliders if total budget is changed
	old_budget = max_budget
	max_budget = value
	for slider in sliders_list:
		if max_budget > old_budget:
			slider.max_value = max_budget
			slider.value *= max_budget/old_budget
		else:
			slider.value *= max_budget/old_budget
			slider.max_value = max_budget
	emit_signal("chart_change")		# tells PieChart to update the charts
	emit_signal("percent_enabled", percent_state)	# tells PieChart if percentage should be displayed

func _on_MiscControls_enable_percentage(state):		# enables percentage value display
	percent_state = state
	emit_signal("percent_enabled", state)


func _on_MiscControls_baseline(base_value):	# forces an update to everything
	_on_BudgetEditor_value_changed(base_value)	
	budget_editor.value = base_value


func _on_PieChart_color_changed(color_list):	# modifies slider color based on chart color
	color_list.invert()
	for i in sliders_list.size():
		var slider_color = StyleBoxFlat.new()	# creates a custom texture matching pie chart color
		slider_color.set_bg_color(color_list[i])
		slider_color.content_margin_bottom = slider_half_width
		slider_color.content_margin_top = slider_half_width
		sliders_list[i].set("custom_styles/slider", slider_color)

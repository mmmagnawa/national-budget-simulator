extends Control

# variables that require loading singletons or other scenes must be defined onready
onready var sliders_list = get_tree().get_nodes_in_group("slider")
onready var sliders_count = sliders_list.size()

onready var baseline_list = DictData.baseline_list
onready var threshold_list = DictData.threshold_list
onready var print_box = get_tree().get_nodes_in_group("print_box")[0]

# initializes some variables
var print_index_subarray = []
var print_index_array = []
var print_index_array_old = []
var print_string = ""
var values_array  = []

# Called when the node enters the scene tree for the first time.
func _ready():		
	values_array.resize(sliders_count)		# dynamically resizes values_array
	for i in sliders_count:
		values_array[i] = sliders_list[i].value
	var _slider_signal = sliders_list[-1].connect("value_changed", self, "_on_Slider_value_changed")
	# this connects the last slider only since it updates the last among the sliders
	
	baseline_list.resize(sliders_count)
	threshold_list.resize(sliders_count)
	for i in sliders_count:
		match threshold_list[i]:
			null:
				threshold_list[i] = []		# replaces null entries from resize with a blank array
		match baseline_list[i]:
			null:
				baseline_list[i] = 0		# replaces null entries from resize with 0

	print_index_subarray.resize( sliders_count )
	print_index_array.resize( sliders_count )
	_on_Slider_value_changed(0)		# calls the function as if a signal was emitted to update sliders


func _on_Slider_value_changed(_value):		# the underscore in argument indicates it is not used
	print_index_array = get_print_index_array()
	if print_index_array_old == print_index_array:
		initialize_index_array(print_index_array, sliders_count)
		return
	var print_text_array = get_print_text_array()
	
	print_index_array_old = print_index_array.duplicate()
	initialize_index_array(print_index_array, sliders_count)
	
	# stores all text in a single multiline string
	for print_fragment in print_text_array:
		if print_fragment == print_text_array[-1]:
			print_string = print_string + print_fragment
		else:
			print_string = print_string + print_fragment + "\n"
	
	# prints everything unless it is blank, in which case it should say it is at status quo
	match(print_string):
		"":
			print_box.bbcode_text = "Current distribution is in status quo"
		_:
			print_box.bbcode_text = print_string	
	print_string = ""	# re-initializes print_string for the next update
	
func initialize_index_array(array, size):	# initializes arrays as neeeded
	array.clear()
	array.resize(size)

func get_print_index_array():		# gets an array of array of threshold keys to be printed
	for index in sliders_count:
		values_array[index] = sliders_list[index].value

		var threshold_subarray = threshold_list[index].duplicate()
		threshold_subarray.append_array([values_array[index], baseline_list[index] ])
		threshold_subarray.sort()
		
		# searches the indices for the current slider value and the baseline value
		var current_index = threshold_subarray.find(values_array[index])
		var baseline_index = threshold_subarray.find(baseline_list[index])

		# the following method only prints all values between the slider value and the baseline value
		print_index_subarray = threshold_subarray.slice(
			min(current_index, baseline_index)+1, max(current_index, baseline_index)-1 )
		print_index_array[index] = print_index_subarray
	return(print_index_array)

func get_print_text_array():		# gets an array of the actual text that will be printed
	var print_text_array = []
	for i in print_index_array.size():
		for print_index in print_index_array[i]:
			var text_data = DictData.dict_list[i]["threshold"][print_index]["text"]		# fetches text
			match(DictData.dict_list[i]["threshold"][print_index]["good"]):
				true:
					var print_text = "[color=#80DEEA][+] %s[/color]"		# positive text
					print_text_array.push_front( print_text % text_data )
				false:
					var print_text = "[color=#ef9a9a][\u2212] %s[/color]"	# negative text
					print_text_array.push_back( print_text % text_data )
				null:
					pass
	return(print_text_array)

func _on_SliderController_chart_change():		# this exists to prevent updating problems
	_on_Slider_value_changed(0)		# updates slider values if the chart gets updated

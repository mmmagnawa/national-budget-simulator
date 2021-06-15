extends Control

onready var sliders_list = get_tree().get_nodes_in_group("slider")
onready var values_array  = []
onready var baseline_list = DictData.baseline_list
onready var threshold_list = DictData.threshold_list
onready var print_box = $PrintBox

# Called when the node enters the scene tree for the first time.
func _ready():
	values_array.resize(sliders_list.size())
	for i in sliders_list.size():
		var _slider_signal = sliders_list[i].connect("print_read", self, "_on_Slider_print_read")
		values_array[i] = sliders_list[i].value

	baseline_list.resize(sliders_list.size())
	threshold_list.resize(sliders_list.size())

	for i in sliders_list.size():
		match threshold_list[i]:
			null:
				threshold_list[i] = []
		match baseline_list[i]:
			null:
				baseline_list[i] = 0
	print(threshold_list)

func _on_Slider_print_read(id, value):
	#values_array[sliders_list.find(id)] = max(value, 0)

	var index = sliders_list.find(id)
	var threshold_comparator = threshold_list[index].duplicate()
	threshold_comparator.append(value)
	threshold_comparator.append(baseline_list[index])
	threshold_comparator.sort()
	var current_index = threshold_comparator.find(value)
	var baseline_index = threshold_comparator.find(baseline_list[index])
	var print_index_array = threshold_comparator.slice( 
			min(current_index, baseline_index)+1, max(current_index, baseline_index)-1 )
	var print_text = "" 
	for print_index in print_index_array:
		print_text = print_text + "\n" + str(DictData.dict_list[index]["threshold"][print_index]["text"])
	print(print_text)
	print_box.bbcode_text = print_text
	#print_box.text = print_text
	
	
	
	
func print_to_text():
	pass

extends Node

onready var sectors_list = DictData.sects_list
onready var descs_list = DictData.desc_list

onready var sliders_list = get_tree().get_nodes_in_group("slider")
onready var charts_list = get_tree().get_nodes_in_group("chart")
onready var canvaslabels_list = get_tree().get_nodes_in_group("canvaslabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	var charts_length = charts_list.size()
	
	var sectors = sectors_list.duplicate()
	var descs = descs_list.duplicate()
	
	#resizes both sectors and descs so that the code does not break if you change slider count
	sectors.resize( charts_length )
	sectors.invert()
	descs.resize( charts_length )
	descs.invert()
	
	var hover_text = []
	var subhover_text = []
	for i in charts_length:
		match sectors_list[i]:		# replaces null entries (from resize) into "N/A"
			null:
				hover_text.append("N/A")
				subhover_text.append("N/A")
			_:
				hover_text.append(sectors[i])
				subhover_text.append(descs[i])

		# defines hover text and subtext for each sector
		var canvaslabel = canvaslabels_list[i]
		canvaslabel.get_node("VBoxContainer").get_node("MainLabel").text = hover_text[i]
		canvaslabel.get_node("VBoxContainer").get_node("SubLabel").text = subhover_text[i]
		sliders_list[i].connect("value_changed", charts_list[i], "_on_Slider_value_changed")

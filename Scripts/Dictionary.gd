extends Node

# this dictionary contains the analysis output messages
# name: name of sector, displayed on chart mouseover
# desc: description, displayed on chart mouseover as subtext
# abbreviation: gets displayed to the right of the slider
# baseline: status quo value based on 2021's budget which is used as reference for everything
# threshold: lists all values that  changes that happens once a threshold value is hit
	# good: boolean; whether this is positive [+], or negative [-]
	# text: actual text to print out

var dict_list = {		
	0: {"name": "Education", "desc": "DepEd, CHED, SUCs, DTI-TESDA", "abbreviation": "Education", "baseline": 754.4, "threshold": {
		490.4: {"good": false, "text": "Lack of schools for face-to-face classes"},
		565.8: {"good": false, "text": "Deterioration of school facilities"},
		641.2: {"good": false, "text": "Education workers seeking new jobs"},
		678.96: {"good": false, "text": "Lower educational attainment"},
		716.7: {"good": false, "text": "Lower quality of books and resources"},
		792.2: {"good": true, "text": "More scholarship opportunities for students"},
		829.8: {"good": true, "text": "Higher quality of books/resources"},
		867.6: {"good": true, "text": "Increased salary and benefits for teachers"},
		943: {"good": true, "text": "Renovation of existing schools"},
		980.7: {"good": true, "text": "More basic education facilities for K-12"}
		}},
	1: {"name": "Agriculture & Food", "desc": "DA, DAR, FDA", "abbreviation": "Agriculture & Food", "baseline": 242.6,  "threshold": {
		182: {"good": false, "text": "Malnutrition due to hunger"},
		194.1: {"good": false, "text": "High levels of food insecurity"},
		206.2: {"good": false, "text": "Higher demand for imports"},
		218.3: {"good": false, "text": "Price hike on goods"},
		230.5: {"good": false, "text": "Decline in agricultural development"},
		254.7: {"good": true, "text": "Health benefits for farmers"},
		278.9: {"good": true, "text": "Insurance for land during typhoons"},
		291.1: {"good": true, "text": "Higher quality of rice and crop yields"},
		315.4: {"good": true, "text": "Lesser price of goods in the market"},
		327.5: {"good": true, "text": "Larger possibility of exportation"}
		}},
	2: {"name": "Defense", "desc": "AFP, PNP, DILG, NBI", "abbreviation": "Defense", "baseline": 399.9,  "threshold": {
		300: {"good": false, "text": "Unprepared for any international disputes"},
		340: {"good": false, "text": "Less weaponry"},
		360: {"good": false, "text": "Fewer number of deployable units"},
		419.9: {"good": true, "text": "Better military and criminology schools"},
		439.9: {"good": true, "text": "Improved arms and unit transportation"},
		460: {"good": true, "text": "Emergency funding for intel and deployment"},
		500: {"good": true, "text": "Improved defense strength and training"}
		}},
	3: {"name": "Health & Medicine", "desc": "DOH, PhilHealth", "abbreviation": "Health", "baseline": 203.1,  "threshold": {
		162.5: {"good": false, "text": "Lack of resources during health emergencies"},
		172.6: {"good": false, "text": "Lack of medical supplies"},
		192.9: {"good": false, "text": "Lack of funds for public hospital employees"},
		223.4: {"good": true, "text": "Increase in health care workers"},
		243.7: {"good": true, "text": "More provisions in individual healthcare"},
		264: {"good": true, "text": "Adequate medical supplies, equipment"},
		304.7: {"good": true, "text": "More public hospitals"}
		}},
	4: {"name": "Social Services", "desc": "DSWD, DHSUD", "abbreviation": "Social Services", "baseline": 803.8,  "threshold": {
		683.2: {"good": false, "text": "Worsened effects of poverty"},
		844: {"good": true, "text": "More benefits for PWDs and senior citizens"},
		884.2: {"good": true, "text": "More social service workers"},
		924.4: {"good": true, "text": "Better life for foster children"},
		1005: {"good": true, "text": "Improved well-being for citizens"},
		}},
	5: {"name": "Transportation & Infrastructures", "desc": "DPWH, DOTr", "abbreviation": "Transport & Infrastructure", "baseline": 810.9,  "threshold": {
		600: {"good": false, "text": "More ineffective public transportation"},
		690: {"good": false, "text": "Poor road maintenance, frequent accidents"},
		730: {"good": false, "text": "Higher road congestion"},
		851.4: {"good": true, "text": "Investments on alternative modes of mobility"},
		933: {"good": true, "text": "Renovation of old public transport facilities"},
		1014: {"good": true, "text": "Construction of roads and highways"},
		1054: {"good": true, "text": "More accessible public transportation"},
		1216: {"good": true, "text": "Improvement of public infrastructures"}
		}},
	6: {"name": "Science & Research", "desc": "DOST", "abbreviation": "Science & Research", "baseline": 2.41,  "threshold": {
		1.8: {"good": false, "text": "Heavier reliance on international technology"},
		2.2: {"good": false, "text": "Limited advancement of knowledge"},
		2.3: {"good": false, "text": "Reduction in scientific research"},
		3: {"good": true, "text": "Higher number of DOST scholars"},
		4.82: {"good": true, "text": "Increase in funded local research"},
		7.23: {"good": true, "text": "Significant technological advancements"}
		}},
	7: {"name": "International Debt", "desc": "All loans must come to an end", "abbreviation": "International Debt", "baseline": 531.5,  "threshold": {
		300: {"good": null, "text": ""},
		558: {"good": null, "text": ""},
		584: {"good": null, "text": ""},
		}},
	8: {"name": "Others", "desc": "Everything else goes under this umbrella sector", "abbreviation": "Others", "baseline": 0,  "threshold": {
		0: {"good": null, "text": ""}
		}},
	9: {"name": "Corruption", "desc": "A black void in the budget that mysteriously disappeared", "abbreviation": "Corruption", "baseline": 0,  "threshold": {
		0: {"good": null, "text": ""}
		}},	
}

var fixed_colors = [	# the colors used when "Fixed Colors" is enabled
	Color("#000000"),	# black
	Color("#757575"),	# grey 600
	Color("#3F51B5"),	# indigo
	Color("#9C27B0"),	# purple
	Color("#2196F3"),	# blue
	Color("#00BCD4"),	# cyan
	Color("#009688"),	# teal
	Color("#4CAF50"),	# green
	Color("#FFC107"),	# orange
	Color("#F44336"),	# red primary
]	# due to the order of scenes being loaded, the last in the list should be first sector's color


var sects_list = []
var baseline_list = []
var threshold_list = []
var desc_list = []
var abbrev_list = []

func get_sectors_list():	# gets a list of all sector names in dict_list
	var blank_list = []
	for index in dict_list.keys():
		blank_list.append(dict_list[index]["name"])
	return blank_list
	
func get_baseline_list():	# gets an array of all baseline values in dict_list
	var blank_list = []
	for index in dict_list.keys():
		blank_list.append(dict_list[index]["baseline"])
	return blank_list

func get_threshold_list():	# gets an array of all threshold values per entry in dict_list
	var blank_list = []
	var blank_sublist = []
	for index in dict_list.keys():
		blank_sublist = dict_list[index]["threshold"].keys()
		blank_list.append(blank_sublist)
	return blank_list

func get_desc_list():		# gets a list of descriptions from dict_list
	var blank_list = []
	for index in dict_list.keys():
		blank_list.append(dict_list[index]["desc"])
	return blank_list
	
func get_abbrev_list():		# gets a list of abbreviations from dict_list
	var blank_list = []
	for index in dict_list.keys():
		blank_list.append(dict_list[index]["abbreviation"])
	return blank_list

func _ready():
	sects_list = get_sectors_list()
	baseline_list = get_baseline_list()
	threshold_list = get_threshold_list()
	desc_list = get_desc_list()
	abbrev_list = get_abbrev_list()

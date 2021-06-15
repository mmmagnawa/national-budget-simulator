extends PanelContainer

export var label_offset = 12	# offset of the hover text from the mouse's position
onready var default_pos = self.rect_global_position		# stores its default position as a variable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if self.visible == true:
		var mouse_position = get_global_mouse_position()	# moves with mouse cursor
		self.rect_global_position = mouse_position + label_offset*Vector2.ONE	# applies offset

func _on_Area2D_mouse_entered():	# shows hover text and lets the _process handle positioning
	self.visible = true

func _on_Area2D_mouse_exited():		# hides hover text and resets position
	self.visible = false
	self.rect_global_position = default_pos

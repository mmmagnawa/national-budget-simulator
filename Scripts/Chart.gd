extends TextureProgress

onready var hit_box = $Area2D/CollisionPolygon2D
#onready var hit_box2 = $Area2D/CollisionPolygon2D2		#duplicate CollisionPolygon2D if hitbox breaks
var hit_shape = []

var theta = 0
var phi = 0
var psi = 0

export var radius = 200		# radius of chart, default is 200
export var polygon_points = 8	# number of points for the chart's collision 

onready var divider = polygon_points - 2

# Called when the node enters the scene tree for the first time.
func _ready():
	self.rect_pivot_offset = self.rect_size/2
	hit_shape.resize(polygon_points)
	hit_box.polygon.resize(polygon_points)

	for i in polygon_points:
		hit_shape[i] = Vector2(0,0)

func _on_Area2D_mouse_entered():
	$AnimationPlayer.play("explode")
	
func _on_Area2D_mouse_exited():
	$AnimationPlayer.play_backwards("explode")

func _on_Slider_value_changed(_some_val):	# underscore in argument indicates it does not get used
	theta = value/100*TAU	#converts Progress in [0, 100] into degree angle in [0, 360]
	psi = radial_initial_angle/360*TAU #converts to radians
	hit_shape[0] = Vector2(0, 0)	# first point is always at object's origin (center)
	for i in hit_shape.size()-1:
		hit_shape[i+1] = Vector2(radius*sin(psi + i*theta/divider), -radius*cos(psi + i*theta/divider))
	
	hit_box.polygon = hit_shape
	#hit_box2.polygon = hit_shape
	# there used to be 2 polygons per chart due to a bug that somehow resolved itself

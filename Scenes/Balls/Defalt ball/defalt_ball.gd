extends GenericBall

@export var max_lenght_line : int = 6

#@onready var sprite = $CollisionShape2D
@onready var line_trail : Line2D = $Line2D



func _physics_process(delta) -> void:
	line_trail.add_point(self.global_position + (direction_bullet * 14))
	if line_trail.points.size() > max_lenght_line:
		line_trail.remove_point(0)

	super(delta)

extends Area2D

@export var letter: String = "A"
@export var fall_speed: float = 200

signal letter_caught(letter: String)

@onready var label = $Label

func _ready():
	label.text = letter
	connect("body_entered", Callable(self, "_on_body_entered"))  # ✅ Keep only ONE of these
	print("Letter ready with label: ", label.text)

func _physics_process(delta):
	position.y += fall_speed * delta
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()  # Clean up if it falls off screen

func _on_body_entered(body):
	print("Something entered:", body.name)
	if body.name == "Aria":
		print("Emitting letter:", letter)
		emit_signal("letter_caught", letter)
		queue_free()

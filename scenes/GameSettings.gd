extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# Assitance with ChatGPT, refer to: https://chatgpt.com/share/67b80003-f7fc-8002-8101-713356e7b30f
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_CTRL:
		if $"CrouchArea".overlaps_body($Node2D):  # Ensure player is in the area
			$"Victory".visible = true
			$"Objective".visible = false

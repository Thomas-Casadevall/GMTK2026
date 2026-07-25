extends Node2D

var count:int;

signal rocket_launched

var is_launched = false
var is_crashed = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = 5;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func countdown() -> void:
	if is_launched == false:
		count -=1;
		$Countdown_container/Countdown_label.text = str(count)
		print("je descend de 1 !, reste : ", count)
		print(self.get_instance_id())
		
		if count < 0:
			is_crashed = true
			$Countdown_container/Countdown_label.text = "Crashed !"

func space_key_pressed() -> bool:
	print("scene received space")
	if count == 0:
		$Countdown_container/Countdown_label.text = "Launched !"
		is_launched = true
		GlobalSignalHandler.emit_signal("rocket_launched")
		return true
	return false

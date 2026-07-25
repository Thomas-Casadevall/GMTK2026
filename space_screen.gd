extends Node2D

var count:int;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = 5;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func countdown() -> void:
	print("je descend de 1 !, reste : ", count)
	count -=1;
	print(self.get_instance_id())
	pass

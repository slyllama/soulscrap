extends Area3D

@export var component_id := "blank"
@export var collect_time := 1.0

var in_range = false
var started = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if in_range and !started:
			started = true # can't start twice
			Global.start_cast.emit(collect_time)

func _ready() -> void:
	$NodeSpatial.text = Components.get_title(component_id)
	$NodeSpatial.update_appearance()
	
	Global.cast_stopped.connect(func(_success):
		if _success and in_range:
			## TODO: collect
			PlayerData.add_to_deck(component_id)
			queue_free())

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		$FG.visible = true
		in_range = true

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		$FG.visible = false
		in_range = false

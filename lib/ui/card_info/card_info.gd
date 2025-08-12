extends "res://lib/ui/container/container.gd"

func update(id) -> void:
	if Input.is_action_pressed("left_click"): return
	if $Timer.is_stopped(): undissolve()
	
	shrink()
	$VBox/Header/Title.text = Components.get_title(id)
	$VBox/Header/Icon.texture = Components.get_texture(id)
	$VBox/Description.text = Components.get_description(id)
	
	$Timer.start()

func dismiss() -> void:
	if Input.is_action_pressed("left_click"): return
	
	await get_tree().process_frame
	var _c = get_window().gui_get_hovered_control()
	if !_c is CardIcon: dissolve()
	elif _c.id == "blank": dissolve()
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		dismiss()

func _ready() -> void:
	dissolve()
	Global.card_hovered.connect(update)
	Global.card_unhovered.connect($Timer.start)
	get_window().focus_exited.connect(dismiss)

func _on_timer_timeout() -> void:
	dismiss()

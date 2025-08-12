extends "res://lib/ui/container/container.gd"

func update(id) -> void:
	if $Timer.is_stopped(): undissolve()
	$VBox/Header/Title.text = Components.get_title(id)
	$Timer.start()
	shrink()

func dismiss() -> void:
	await get_tree().process_frame
	if !get_window().gui_get_hovered_control() is CardIcon:
		dissolve()

func _ready() -> void:
	dissolve()
	Global.card_hovered.connect(update)
	Global.card_unhovered.connect($Timer.start)
	get_window().focus_exited.connect(dismiss)

func _on_timer_timeout() -> void:
	dismiss()

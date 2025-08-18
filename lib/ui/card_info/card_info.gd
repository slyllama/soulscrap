@tool
extends "res://lib/ui/container/container.gd"

const ICON_PATH = "res://lib/ui/card_info/card_stat/stat_icons/"
const CardStat = preload("res://lib/ui/card_info/card_stat/card_stat.tscn")
const StatIcons = {
	"damage": preload(ICON_PATH + "icon_damage.png"),
	"tempo_cost": preload(ICON_PATH + "icon_tempo_cost.png"),
	"range": preload(ICON_PATH + "icon_range.png") }

func add_card_stat(id, parameter: String, component_title: String) -> void:
	var _data = Components.component_library[id]
	if parameter in _data:
		var _c = CardStat.instantiate()
		_c.description = component_title + ": [color=fff0b5]" + str(_data[parameter]) + "[/color]"
		if parameter in StatIcons: _c.icon = StatIcons[parameter]
		$VBox/ActiveStats.add_child(_c)

func update(id) -> void:
	if Input.is_action_pressed("left_click"): return
	if $Timer.is_stopped(): undissolve()
	for _n in $VBox/ActiveStats.get_children():
		_n.free()
	
	# Fill in basic component details
	$VBox/Header/Title.text = Components.get_title(id)
	$VBox/Header/Icon.texture = Components.get_texture(id)
	$VBox/Description.text = Components.get_description(id)
	
	# Add in additional details
	# TODO: might be able to streamline this somehow
	if id in Components.component_library:
		add_card_stat(id, "damage", "Damage")
		add_card_stat(id, "tempo_cost", "Tempo")
		add_card_stat(id, "range", "Range")
		var _cd = Components.get_cooldown(id)
		if _cd > 0.0:
			$VBox/Header/CD.text = str(_cd) + "s"
		
	if $VBox/ActiveStats.get_child_count() > 0:
		$VBox/ActiveSubtitle.visible = true
	else: $VBox/ActiveSubtitle.visible = false
	
	# Resize the card to fit all of its modules
	await get_tree().process_frame
	shrink()
	size.y = $VBox.get_size().y + 32.0
	position.y = (get_window().size.y / 2.0
		/ get_window().content_scale_factor - size.y / 2.0)
	
	$Timer.start()

func dismiss() -> void:
	if Input.is_action_pressed("left_click"): return
	
	await get_tree().process_frame
	var _c = get_window().gui_get_hovered_control()
	if !_c is CardIcon: dissolve()
	elif _c.id == "blank": dissolve()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("left_click"):
		dismiss()

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	dissolve()
	Global.card_hovered.connect(update)
	Global.card_unhovered.connect($Timer.start)
	get_window().focus_exited.connect(dismiss)

func _on_timer_timeout() -> void:
	dismiss()

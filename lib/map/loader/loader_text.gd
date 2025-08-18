extends RichTextLabel

const TEXT_SEQUENCE = [
	"124DFV76CMP97Y2",
	"4CXVL5A94NGS2CX",
	"1DVMLOADING56AY",
	"67DXLOAD1NG4323",
	"23DZLOADING6FG2",
	"12ZY9O45IXZ2132"
]

var _text_pos = 0

func _on_text_timer_timeout() -> void:
	if _text_pos >= TEXT_SEQUENCE.size() - 1:
		_text_pos = 0
	else: _text_pos += 1
	text = TEXT_SEQUENCE[_text_pos]

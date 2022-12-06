extends CanvasLayer

signal perde

func _ready():
	$municao.show()
	$vidas.show()
	$pontos.show()
	$msg.hide()

func atualizamunicao(novovalor):
	$municao/tmunicao.text = str(novovalor)

func atualizapontos(novovalor):
	$pontos/tpontos.text = str(novovalor)

func atualizavidas(novovalor):
	$vidas/tvidas.text = str(novovalor)
	
func perde():
	$municao.hide()
	$pontos.hide()
	$vidas.hide()
	$msg.show()
	emit_signal("perde")
	yield(get_tree().create_timer(5.0), "timeout")
	get_tree().reload_current_scene()

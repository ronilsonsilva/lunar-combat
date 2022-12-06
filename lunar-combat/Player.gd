extends KinematicBody

# variáveis de controle
var vidas = 100
var pontos = 0
var municao = 20

# variáveis de câmera
var sensibilidade = 0.4
var angulominimo = -90
var angulomaximo = 90

# variáveis físicas
var vmovimento = 5
var gravidade = 1.62
var fpulo = 4

# auxílio
onready var camera = get_node("Camera")
var vel : Vector3 = Vector3()
var vmouse : Vector2 = Vector2()

onready var localtiro = get_node("Camera/arma/bala")
onready var bala = preload("res://Bala.tscn")
onready var hud = get_node("/root/Main/HUD")

func _ready():
	$tema.play()
	hud.atualizavidas(vidas)
	hud.atualizapontos(pontos)
	hud.atualizamunicao(municao)

func _input(event):
	if event is InputEventMouseMotion:
		vmouse = event.relative
	if Input.is_action_just_pressed("tiro"):
		atira()
		
func atira():
	if municao > 0:
		$tiro.play()
		var novabala = bala.instance()
		get_node("/root/Main").add_child(novabala)
		novabala.global_transform = localtiro.global_transform
		novabala.scale = Vector3.ONE
		municao -= 1
		hud.atualizamunicao(municao)
	
	
	
func _process(delta):
	# Rotaciona a camera ao longo do eixo x
	camera.rotation_degrees -= Vector3(rad2deg(vmouse.y),0,0) * sensibilidade * delta

	# Limita a rotação vertical com os ângulos máximo e mínimo
	camera.rotation_degrees.x - clamp(camera.rotation_degrees.x,angulominimo,angulomaximo)
	
	# Rotaciona a camera ao longo do eixo y
	rotation_degrees -= Vector3(0,rad2deg(vmouse.x),0) * sensibilidade * delta
	
	# Resetar vmouse
	vmouse = Vector2()
	
func _physics_process(delta):
	# Reseta a velocidade em x, e em z
	vel.x = 0
	vel.z = 0
	var input = Vector2()
	
	# Entradas do teclado
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x += 1
	
	# Sem movimento na diagonal
	input = input.normalized()
	
	# Obter direções
	var frente = global_transform.basis.z 
	var direita = global_transform.basis.x 
	
	# Aplicar a gravidade
	vel.y -= gravidade*delta
	
	# Alterar a velocidade
	vel.z = (frente * input.y + direita * input.x).z * vmovimento
	vel.x = (frente * input.y + direita*input.x).x * vmovimento
	
	# Movimentando o player
	vel = move_and_slide(vel, Vector3.UP)
	
	# Pule se pressionar a tecla e se estiver no chão
	if Input.is_action_pressed("pulo") and is_on_floor():
		vel.y = fpulo
	
func toma_pontos(ganhou):
	pontos += ganhou
	$morteinimigo.play()
	hud.atualizapontos(pontos)

func toma_vida(quanto):
	vidas += quanto
	$vidas.play()
	hud.atualizavidas(vidas)

func toma_dano(dano):
	vidas -= dano
	$dano.play()
	hud.atualizavidas(vidas)
	if vidas == 0:
		morre()

func morre():
	hud.perde()

func toma_municao(quanto):
	municao += quanto
	$municao.play()
	hud.atualizamunicao(municao)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	






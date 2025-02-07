extends Control

@onready var http_request = $HTTPRequest  # Référence au nœud HTTPRequest

var donneIngredient = null
func _ready() -> void:
	http_request.request_completed.connect(_on_http_request_request_completed)  # Connecte le signal de réponse

func _on_pressed() -> void:
	#print("Mande" + "test")  # Vérification de l'appui sur le bouton
	#var url = "http://192.168.1.173:8000/api/admin/ingredients/all"
	#var error = http_request.request(url)  # Envoi de la requête HTTP
#
	#if error != OK:
		#print("Erreur lors de l'envoi de la requête :", error)
	print("Requête POST envoyée")
	var url = "http://192.168.1.173:8000/api/admin/ingredients/all"
	var headers = ["Content-Type: application/json"]
	var data = {
		"email":"amdin@gmail.com",
		"mdp":"admin"
	}
	var body = JSON.stringify(data)
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET, body)

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:  # Vérifie si la requête a réussi
		var response_text = body.get_string_from_utf8()  # Convertir en texte
		var json = JSON.parse_string(response_text)  # Parser le JSON
		if json:
			donneIngredient = json
			print("Données reçues :", donneIngredient)  # Affiche les données
		else:
			print("Erreur de parsing JSON")
	else:
		print("Erreur de requête, code :", response_code)


func _on_draw() -> void:
	# Si aucune donnée n'est encore chargée, on ne fait rien
	if donneIngredient == null:
		return

	var y = 250
	for ingredient in donneIngredient:
		draw_string(get_theme_font("font"), Vector2(100, y), "- " + ingredient.nomIngredient, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color.WHITE)
		y += 30  # Décalage vertical entre chaque ligney += 30  # Décalage vertical entre chaque ligne

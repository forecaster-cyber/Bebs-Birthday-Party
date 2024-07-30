extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():

	await insert_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func insert_data():
	var collection: FirestoreCollection = Firebase.Firestore.collection("experiment")
	var data: Dictionary = {"name": "serge",
	"gender": "m"
	}
	await collection.add("fdgdfgdgdfgg,dfffffffffffffnjxzc,nfsd", data)

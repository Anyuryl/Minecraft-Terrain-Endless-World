extends Spatial
tool

onready var noise = OpenSimplexNoise.new()
onready var Player:KinematicBody = get_node("Player")
onready var Chunk:PackedScene=preload("res://CHUNK.tscn")
onready var ColisionChunk:PackedScene=preload("res://ColisionChunk.tscn")

var CurrentSpawnedChunkCoordinates=[]
var CurrentSpawnedCollisionChunkCoordinates=[]
var CurrentSpawnedChunksReferences=[]
var CurrentSpawnedCollisionsChunksReferences=[]

var ChunksInvisibles=[]
var CollisionsChunksInvisibles=[]
var LostPlayerCoordinates:Vector2
const ChunkSize:float=5.0
const CollisionChunkSize:float=2.0
const RenderRange:int=10
const CollisionRenderRange:int=3
var Start:bool=false

func _ready():
	randomize()
	noise.seed=randi()
	noise.octaves=6
	noise.period=128
	noise.persistence=0.5
	SpawnNewChunksWithinRenderRange()
	SpawnNewCollisionChunksWithinRenderRange()
	Start=true
	#kkkkkkkkkkk

func _process(_delta)->void:
	###Voce pode colocar um if para so atualizar o tick quando o player andar escolha ex if Input.is_action_pressed('left') and ....
	if (GetPlayerCoordinates()!=LostPlayerCoordinates):
		#skskskkskskks
		LostPlayerCoordinates=GetPlayerCoordinates()
		PlayerHasChangedCoordinates()

func PlayerHasChangedCoordinates()->void:
	SpawnNewChunksWithinRenderRange()
	DestroyChunksOutsideRenderRange()

func SpawnNewChunksWithinRenderRange()->void:
	for x in range(-RenderRange,RenderRange):
		for z in range(-RenderRange,RenderRange):
			var PlayerCoordinates:Vector2=GetPlayerCoordinates()
			var ChunkCoordinates:Vector2=Vector2(x+PlayerCoordinates.x,z+PlayerCoordinates.y)
			var Cord:Vector2=Vector2(x*ChunkSize,z*ChunkSize)
			if Should_Spawn_Chunk(ChunkCoordinates,Cord.length()):
				if Start==false:
					Spawn_Chunks_at_This_Loops_Coordinates(ChunkCoordinates)
				else:
					Realocate_Chunk_at_this_loops_coordinates(ChunkCoordinates)
func SpawnNewCollisionChunksWithinRenderRange()->void:
	pass

func GetPlayerCoordinates()->Vector2:
	var PlayerVector:Vector3=Player.translation/ChunkSize
	return Vector2(int(PlayerVector.x),int(PlayerVector.z))

func Should_Spawn_Chunk(ChunkCoordinates,Cord)->bool:
	if not(ChunkCoordinates in CurrentSpawnedChunkCoordinates) and Cord<=(RenderRange*ChunkSize):
		return true
	else:
		return false

func Spawn_Chunks_at_This_Loops_Coordinates(ChunkCoordinates)->void:
	var new_chunk=Chunk.instance()
	new_chunk.transform.origin=Vector3(ChunkCoordinates.x*ChunkSize,0,ChunkCoordinates.y*ChunkSize)
	CurrentSpawnedChunkCoordinates.append(ChunkCoordinates)
	new_chunk.noise=noise
	call_deferred('add_child',new_chunk)
	CurrentSpawnedChunksReferences.append(new_chunk)

func Realocate_Chunk_at_this_loops_coordinates(ChunkCoordinates)->void:
	if len(ChunksInvisibles)>0:
		ChunksInvisibles[0].translation=Vector3(ChunkCoordinates.x*ChunkSize,0,ChunkCoordinates.y*ChunkSize)
		CurrentSpawnedChunkCoordinates.append(ChunkCoordinates)
		CurrentSpawnedChunksReferences.append(ChunksInvisibles[0])
		ChunksInvisibles[0]._update()
		ChunksInvisibles.remove(0)

func DestroyChunksOutsideRenderRange()->void:
	var index=[]
	for i in range(len(CurrentSpawnedChunkCoordinates)-1):
		if i<=(len(CurrentSpawnedChunkCoordinates)-1):
			var Current:Vector2=Vector2(CurrentSpawnedChunkCoordinates[i].x*ChunkSize,CurrentSpawnedChunkCoordinates[i].y*ChunkSize)
			var PlayerVector:Vector3=Player.translation
			#skskkskskks Calculando distancia entre vetores skksksks
			var new:Vector2=Vector2(Current.x-PlayerVector.x,Current.y-PlayerVector.z)
			new=Vector2(new.x*new.x,new.y*new.y)
			var distance = sqrt(new.x+new.y)
			if distance>(RenderRange*ChunkSize):
				ChunksInvisibles.append(CurrentSpawnedChunksReferences[i])
				CurrentSpawnedChunksReferences[i].visible=false
				CurrentSpawnedChunkCoordinates.remove(i)
				CurrentSpawnedChunksReferences.remove(i)

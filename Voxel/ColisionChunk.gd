extends StaticBody
tool
onready var noise = OpenSimplexNoise.new()
var RenderRangeXZ:int=2
var RenderRangeY:int=1
var Blocks=[]
var VoxelSize:float=1
var index
onready var Block:PackedScene=preload("res://Block.tscn")
func _ready()->void:
	for x in range(RenderRangeXZ):
		for z in range(RenderRangeXZ):
			var h=translation/VoxelSize
			var xx:int =round(h.x)+x
			var zz:int=round(h.z)+z
			var hh = round(noise.get_noise_2d((xx/VoxelSize),(zz/VoxelSize))*50)
			for y in range(RenderRangeY):
				var new_block=Block.instance()
				new_block.translation=Vector3(x,hh-y,z)
				call_deferred('add_child',new_block)
				Blocks.append(new_block)


func _update()->void:
	index=0
	for x in range(RenderRangeXZ):
		for z in range(RenderRangeXZ):
			var h=translation/VoxelSize
			var xx:int =round(h.x)+x
			var zz:int=round(h.z)+z
			var hh = round(noise.get_noise_2d((xx/VoxelSize),(zz/VoxelSize))*50)
			for y in range(RenderRangeY):
				Blocks[index].translation=Vector3(x,hh-y,z)
				index+=1


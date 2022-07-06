extends MultiMeshInstance
tool

onready var noise = OpenSimplexNoise.new()
var RenderRangeXZ:int=5
var RenderRangeY:int=4
var Blocks=[]
var VoxelSize:float=1
var index

func _ready()->void:
	_update()

func _update()->void:
	self.multimesh=MultiMesh.new()
	self.multimesh.transform_format=MultiMesh.TRANSFORM_3D
	self.multimesh.instance_count=RenderRangeXZ*RenderRangeXZ*RenderRangeY
	self.multimesh.visible_instance_count=self.multimesh.instance_count
	var mesh:CubeMesh=CubeMesh.new()
	mesh.size=Vector3(1,1,1)
	self.multimesh.mesh=mesh
	index=0
	for x in range(RenderRangeXZ):
		for z in range(RenderRangeXZ):
			var h=translation/VoxelSize
			var xx:int =round(h.x)+x
			var zz:int=round(h.z)+z
			var hh = round(noise.get_noise_2d((xx/VoxelSize),(zz/VoxelSize))*50)
			for y in range(RenderRangeY):
				self.multimesh.set_instance_transform(index,Transform(Basis(),Vector3(x,hh-y,z)))
				index+=1
	visible=true

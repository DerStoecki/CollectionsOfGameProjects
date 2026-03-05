class_name MeshColorUtility extends MeshInstance3D

var baseColor: Color
var baseTransparency : int
var activeMaterialPreLoad : StandardMaterial3D = preload("res://assets/materials/BluePrintMaterial.tres")
var activeMaterial : StandardMaterial3D
var originalMaterial: StandardMaterial3D
# TODO Material should be created (only for BP state, otherwise use standardMaterial)

func _ready():
	self.originalMaterial  = get_active_material(0) 
	self.activeMaterial = activeMaterialPreLoad.duplicate();
	self.set_surface_override_material(0, self.activeMaterial);
	self.baseColor = activeMaterial.get_albedo()
	self.baseTransparency = activeMaterial.get_transparency()

func setAllColorsTo(color : Color):
	#TODO get all activeMaterials
	self.activeMaterial.set_albedo(color)
	pass

func setAllTransparencyTo(transparency : int) :
	self.activeMaterial.set_transparency(transparency)
	pass
	
func reset(visible:  bool) :
	self.set_surface_override_material(0, self.originalMaterial);
	self.activeMaterial = null;
	self.visible = visible
	pass

extends Node
class_name RandomRoomIdToTotemGenerator

## TODO Maybe move this to game Manager.

@export var roomMinRange: int = 1
@export var roomMaxRange: int = 28
## CustomSeed used to determine RNG
@export var customSeed : String = "ISeeYou"
@export var generatedDone: bool = false

var exitStrategyRoomId : int = 0
var maxTries : int = 10

## Room ID to Totem
var dictionary: Dictionary[int, int] = {}

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal generated_done(dictionary: Dictionary[int, int])

func generateSeed():
	self.setSeed(str(self.rng.get_seed()))
	
func setSeed(givenSeed: String):
	self.customSeed = givenSeed
	if givenSeed.is_valid_int():
		self.rng.set_seed(hash(self.customSeed))
	else:
		self.rng.set_seed(int(self.customSeed))	

func generateRoomToIds():
	var curTries = 0
	for x in range(1, 11):
		var roomId : int = randomRoomId()
		curTries = 0
		while self.dictionary.has(roomId) and curTries < maxTries:
			roomId = randomRoomId()
			curTries += 1
		if curTries > maxTries:
			roomId = self.getFallbackRoomId()
		self.dictionary[roomId] = x
	self.generatedDone = true
	self.generated_done.emit(self.dictionary)
	
	
func randomRoomId() -> int :
	return rng.randi_range(roomMinRange, roomMaxRange)
	
func getFallbackRoomId() -> int:
	print("Fallback needed")
	while self.dictionary.has(self.exitStrategyRoomId):
		self.exitStrategyRoomId+= 1
	return self.exitStrategyRoomId

func getRandf() -> float:
	var randomf : float = self.rng.randf()
	if self.isTest:
		print("Random float determined: %s" %  [randomf])
	return randomf
	

func testFallback():
	for x in range(1,11):
		self.dictionary[getFallbackRoomId()] = x

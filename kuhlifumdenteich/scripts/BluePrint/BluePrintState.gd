class_name BluePrintState

enum state { #
	INIT, # BluePrintState await "set" and depending on world grid -> set albedo
	WAITING, # Base only
	SET_FOR_PROGRESS, #Wait for Building / show Symbol
	IN_PROGRESS,  # Start Build animation
	PRE_DONE,  # Show symbol / einweihung
	DONE, # ResourceCreator decorate with "effectiveness"
	SET_FOR_DESTRUCTION, # Decorator -> destruction symbol
	DESTRUCTION,  # Deconstruct
	CLEANUP # Cleanup mess -> and then destroy self.
	}

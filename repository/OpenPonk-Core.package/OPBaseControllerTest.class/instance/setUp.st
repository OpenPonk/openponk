running
setUp
	super setUp.
	controller := self controllerClass new.
	diagramController := self diagramControllerClass new.
	diagramController model: self diagramModelClass new.
	diagramController view: RTView new.
	model := self newModel
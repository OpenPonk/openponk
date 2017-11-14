diagram handling
newDiagramControllerFor: aModel
	^ plugin diagramControllerClass new
		model: aModel;
		editor: self;
		workbenchAnnouncer: self workbench announcer;
		yourself
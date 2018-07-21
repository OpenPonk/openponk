execution
prepareFullExecutionInContext: aToolContext
	super prepareFullExecutionInContext: aToolContext.
	diagramController := aToolContext diagramController.
	view := diagramController view.
	figure := aToolContext figure
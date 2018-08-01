execution
prepareFullExecutionInContext: aToolContext
	super prepareFullExecutionInContext: aToolContext.
	diagramController := aToolContext diagramController.
	view := diagramController view.
	figures := aToolContext figures.
	figure := aToolContext figure.
	models := aToolContext models.
	controllers := aToolContext controllers
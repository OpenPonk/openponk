tool api
whenCompletedRename
	self
		whenCompleted: [ :ctrl | 
			OPRenameElementCommand executeOn: ctrl model.
			ctrl refreshFigure ]
tool api
whenCompletedRename
	self
		whenCompleted: [ :ctrl | 
			DCRenameElementCommand executeOn: ctrl model.
			ctrl refreshFigure ]
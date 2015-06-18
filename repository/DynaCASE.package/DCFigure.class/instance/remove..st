removing
remove: aFigure
	figures remove: aFigure.
	removedFigures add: aFigure.
	self fullRebuild
destruction
removeController
	self removeOwnedControllers.
	self removeFigure.
	self model: nil.
	self diagramController removeController: self
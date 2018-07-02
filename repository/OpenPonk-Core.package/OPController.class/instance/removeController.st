destruction
removeController
	self diagramController ifNil: [ ^ self ].
	self removeOwnedControllers.
	self removeFigure.
	self model: nil.
	self diagramController removeController: self
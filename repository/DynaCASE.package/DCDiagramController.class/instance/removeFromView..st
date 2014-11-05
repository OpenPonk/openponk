removing
removeFromView: aFigure
	model remove: (self controllerForFigure: aFigure) model	"	controller := self findControllerByView: aViewElement.
	self controllers remove: controller.
	controller view remove"
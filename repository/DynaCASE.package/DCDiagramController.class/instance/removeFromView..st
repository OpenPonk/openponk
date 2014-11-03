removing
removeFromView: aViewElement
	model remove: (self findControllerByView: aViewElement) model	"	controller := self findControllerByView: aViewElement.
	self controllers remove: controller.
	controller view remove"
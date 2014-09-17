as yet unclassified
removeModelElement: aModelElement
	| controller |
	controller := self findControllerByModel: aModelElement.
	self controllers remove: controller.
	controller view remove
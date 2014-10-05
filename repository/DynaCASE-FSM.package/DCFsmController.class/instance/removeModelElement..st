as yet unclassified
removeModelElement: aModelElement
	| controller |
	controller := self findControllerByModel: aModelElement.
	self controllers remove: controller.
"	(controller isKindOf: DCFsmVertexController)
		ifTrue: [ 
			controller model incoming do: [ :each | self model remove: each ].
			controller model outgoing do: [ :each | self model remove: each ] ]."
	controller view remove
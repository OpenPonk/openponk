as yet unclassified
createEdgeFrom: fromElement to: toElement
	| builder edge label sourceMultiplicityLabel targetMultiplicityLabel |
	builder := DCRTRelationshipBuilder new.
	edge := builder createEdgeFrom: fromElement to: toElement.
	self parent view add: edge.

	label := builder addLabelTo: edge.
	builder constraint: label balance: 0.5 offset: -12.
	builder updateLabel: label whenChanged: self model nameHolder.

	sourceMultiplicityLabel := builder addLabelTo: edge.
	sourceMultiplicityLabel shape text: self model startMultiplicity.
	sourceMultiplicityLabel update.
	builder constraint: sourceMultiplicityLabel toSourceDistance: 10 offset: 12.

	targetMultiplicityLabel := builder addLabelTo: edge.
	targetMultiplicityLabel shape text: self model endMultiplicity.
	targetMultiplicityLabel update.
	builder constraint: targetMultiplicityLabel toTargetDistance: 10 offset: 12.

	edge signalUpdate.

	self model
		when: DCElementChanged
		do: [ 
			sourceMultiplicityLabel shape text: self model startMultiplicity.
			sourceMultiplicityLabel update.
			targetMultiplicityLabel shape text: self model endMultiplicity.
			targetMultiplicityLabel update.
			edge signalUpdate ].

	^ edge
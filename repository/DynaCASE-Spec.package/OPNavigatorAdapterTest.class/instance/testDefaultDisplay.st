as yet unclassified
testDefaultDisplay
	self displayFor: diagram equals: diagram name , ' (DCDiagram)'.
	self displayFor: element equals: element name , ' (DCNamedElement)'.
	self displayFor: edge equals: edge name , ' (DCEdge)'
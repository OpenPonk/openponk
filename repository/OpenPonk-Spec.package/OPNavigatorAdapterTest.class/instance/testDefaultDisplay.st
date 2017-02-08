as yet unclassified
testDefaultDisplay
	self displayFor: diagram equals: diagram name , ' (', #OPDiagram, ')'.
	self displayFor: element equals: element name , ' (', #OPNamedElement, ')'.
	self displayFor: edge equals: edge name , ' (', #OPEdge, ')'
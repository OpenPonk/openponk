testing
isFor: anElement
	^ anElement isEdge
		and: [ self environment
				at: #OPUmlEdge
				ifPresent: [ :cls | (anElement model isKindOf: cls) not ]
				ifAbsent: [ true ] ]
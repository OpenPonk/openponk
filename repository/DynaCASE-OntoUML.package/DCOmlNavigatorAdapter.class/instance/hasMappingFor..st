testing
hasMappingFor: anObject
	^ (anObject isKindOf: Element) | (anObject isKindOf: DCOmlDiagram)
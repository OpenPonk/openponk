serializing
serializeDiagram: aDiagram
	| serialized |
	serialized := self serializeDiagramBasic: aDiagram.
	serialized at: #elements put: (aDiagram elements collect: [ :each | self serializeElement: each ]).
	^ serialized
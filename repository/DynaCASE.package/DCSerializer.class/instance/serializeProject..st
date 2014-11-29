serializing
serializeProject: aProject
	| serialized |
	serialized := self serializeProjectBasic: aProject.
	serialized at: #diagrams put: (aProject diagrams collect: [ :each | self serializeDiagram: each ]).
	^ serialized
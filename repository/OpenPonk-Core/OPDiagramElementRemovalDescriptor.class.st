"
Encapsulates a snapshot of a diagram element hierarchy, visual bounds, and routing waypoints prior to removal, supporting visual reconstruction during undo.
"
Class {
	#name : 'OPDiagramElementRemovalDescriptor',
	#superclass : 'Object',
	#instVars : [
		'diagram',
		'diagramElement',
		'owningElement',
		'geometryMemento'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> bounds [
	^ (geometryMemento isKindOf: OPNodeBounds)
		ifTrue: [ geometryMemento ]
		ifFalse: [ nil ]
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> bounds: aNodeBounds [
	geometryMemento := aNodeBounds
]

{ #category : 'initialization' }
OPDiagramElementRemovalDescriptor >> captureFrom: aDiagramElement [
	diagramElement := aDiagramElement.
	owningElement := aDiagramElement owningElement.
	geometryMemento := aDiagramElement captureGeometryMemento
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> diagram: anObject [
	diagram := anObject
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> diagramElement [
	^ diagramElement
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> diagramElement: anObject [
	diagramElement := anObject
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> geometryMemento [
	^ geometryMemento
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> geometryMemento: anObject [
	geometryMemento := anObject
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> owningElement [
	^ owningElement
]

{ #category : 'accessing' }
OPDiagramElementRemovalDescriptor >> owningElement: anObject [
	owningElement := anObject
]

{ #category : 'executing' }
OPDiagramElementRemovalDescriptor >> restoreDiagramElement [

	owningElement ifNotNil: [ :savedOwningElement | diagramElement owningElement: savedOwningElement ].
	diagramElement restoreGeometryFromMemento: geometryMemento
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> sourceDiagramElement [

	geometryMemento isCollection ifFalse: [ ^ nil ].
	geometryMemento isString ifTrue: [ ^ nil ].
	geometryMemento ifEmpty: [ ^ nil ].
	^ geometryMemento first
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> sourceDiagramElement: aDiagramElement [
	geometryMemento
		ifNil: [ geometryMemento := { aDiagramElement . nil . nil } ]
		ifNotNil: [
			(geometryMemento isArray and: [ geometryMemento size >= 1 ])
				ifTrue: [ geometryMemento at: 1 put: aDiagramElement ] ]
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> targetDiagramElement [

	geometryMemento isCollection ifFalse: [ ^ nil ].
	geometryMemento isString ifTrue: [ ^ nil ].
	geometryMemento size < 2 ifTrue: [ ^ nil ].
	^ geometryMemento second
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> targetDiagramElement: aDiagramElement [
	geometryMemento
		ifNil: [ geometryMemento := { nil . aDiagramElement . nil } ]
		ifNotNil: [
			(geometryMemento isArray and: [ geometryMemento size >= 2 ])
				ifTrue: [ geometryMemento at: 2 put: aDiagramElement ] ]
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> waypoints [
	^ (geometryMemento isCollection and: [ geometryMemento isString not and: [ geometryMemento size >= 3 ] ])
		ifTrue: [ geometryMemento third ]
		ifFalse: [ nil ]
]

{ #category : 'accessing - compatibility' }
OPDiagramElementRemovalDescriptor >> waypoints: aCollection [
	geometryMemento
		ifNil: [ geometryMemento := { nil . nil . aCollection } ]
		ifNotNil: [
			(geometryMemento isArray and: [ geometryMemento size >= 3 ])
				ifTrue: [ geometryMemento at: 3 put: aCollection ] ]
]

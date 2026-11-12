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

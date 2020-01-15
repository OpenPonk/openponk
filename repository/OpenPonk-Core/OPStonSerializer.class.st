"
I use STON format as a simple serialization strategy.

!! Warning

If your model relies on Announements to propagate updates between elements, the links will be broken as Announcer will be ommited during serialization.
"
Class {
	#name : #OPStonSerializer,
	#superclass : #OPAbstractSerializer,
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPStonSerializer >> diagramExtension [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonSerializer >> materializeDiagramFrom: aString [
	^ self stonMaterialize: aString
]

{ #category : #convenience }
OPStonSerializer >> materializeMementoFrom: aString [
	| memento |
	memento := self stonMaterialize: aString.
	self flag: 'STON has broken Dictionary materialization for referenced keys, so rehash it manually for now'.
	memento diagram rehash.
	^ memento
]

{ #category : #'serialize/materialize' }
OPStonSerializer >> materializeModelFrom: aString [
	^ self stonMaterialize: aString
]

{ #category : #accessing }
OPStonSerializer >> modelExtension [
	^ 'ston'
]

{ #category : #'serialize/materialize' }
OPStonSerializer >> serializeDiagram: aDiagramMemento [
	^ self stonSerialize: aDiagramMemento
]

{ #category : #convenience }
OPStonSerializer >> serializeMemento: aMemento [
	^ self stonSerialize: aMemento
]

{ #category : #'serialize/materialize' }
OPStonSerializer >> serializeModel: aModel [
	^ self stonSerialize: aModel
]

{ #category : #'ston - serialize/materialize' }
OPStonSerializer >> stonMaterialize: aString [
	^ (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next
]

{ #category : #'ston - serialize/materialize' }
OPStonSerializer >> stonSerialize: anObject [
	^ STON toStringPretty: anObject
]

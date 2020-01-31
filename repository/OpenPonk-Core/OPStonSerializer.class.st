Class {
	#name : #OPStonSerializer,
	#superclass : #OPSerializer,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #formatting }
OPStonSerializer >> formatName [
	^ 'json'
]

{ #category : #convenience }
OPStonSerializer >> materializeMementoFrom: aString [
	| unwrapped |
	unwrapped := (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next.
	^ OPPersistenceMemento
		model:
			(OPStonModelSerializer new
				materializeModelFrom: (unwrapped at: #model))
		diagrams:
			((unwrapped at: #diagrams)
				collect:
					[ :each | OPStonDiagramSerializer new materializeDiagramFromString: each ])
]

{ #category : #convenience }
OPStonSerializer >> serializeDiagrams: diagrams [
	^ STON
		toStringPretty:
			(diagrams
				collect: [ :each | OPStonDiagramSerializer new serializeDiagram: each ])
]

{ #category : #convenience }
OPStonSerializer >> serializeMemento: aMemento [
	^ STON
		toStringPretty:
			(Dictionary
				with: #model -> (OPStonModelSerializer new serializeModel: aMemento model)
				with: #diagrams -> (self serializeDiagrams: aMemento diagrams))
]

{ #category : #'ston - serialize/materialize' }
OPStonSerializer >> stonSerialize: anObject [
	^ STON toStringPretty: anObject
]

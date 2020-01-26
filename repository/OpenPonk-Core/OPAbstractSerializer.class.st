"
I am a serialization interface for undo/redo and persistence.
"
Class {
	#name : #OPAbstractSerializer,
	#superclass : #Object,
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #accessing }
OPAbstractSerializer >> diagramExtension [
	^ self subclassResponsibility
]

{ #category : #loading }
OPAbstractSerializer >> loadDiagramFrom: aFolder [
	(aFolder / 'diagram' , self diagramExtension) exists
		ifFalse: [ ^ nil ].
	^ self materializeDiagramFrom: (aFolder / 'diagram' , self diagramExtension) contents
]

{ #category : #loading }
OPAbstractSerializer >> loadMementoFrom: aFolder [
	^ OPPersistenceMemento
		model: (self loadModelFrom: aFolder)
		diagrams: (self loadViewsFrom: aFolder)
]

{ #category : #loading }
OPAbstractSerializer >> loadModelFrom: aFolder [
	^ self materializeModelFrom: (aFolder / 'model' , self modelExtension) contents
]

{ #category : #loading }
OPAbstractSerializer >> loadViewsFrom: aFolder [
	(aFolder / 'views') exists
		ifFalse: [ ^ nil ].
	^ self loadViewsFrom: aFolder / 'views'
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> materializeDiagramFrom: aString [
	"materialize aString into a diagram memento that will be consumed by your controller"
	^ self subclassResponsibility
]

{ #category : #convenience }
OPAbstractSerializer >> materializeMementoFrom: aString [
	| unwrapped |
	unwrapped := (STON reader
		allowComplexMapKeys: true;
		on: aString readStream) next.
	^ OPPersistenceMemento
		model: (self materializeModelFrom: (unwrapped at: #model))
		diagrams: (self materializeViewsFrom: (unwrapped at: #diagrams))
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> materializeModelFrom: aString [
	"materialize aString into a model instance"
	^ self subclassResponsibility
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> materializeViewFrom: aString [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPAbstractSerializer >> modelExtension [
	^ self subclassResponsibility
]

{ #category : #saving }
OPAbstractSerializer >> saveDiagram: aMemento to: aFolder [
	aMemento diagram ifNil: [ ^ self ].
	(aFolder / 'diagram' , self diagramExtension)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (self serializeDiagram: aMemento diagram) ]
	"stream wantsLineEndConversion: true.
			stream lineEndConvention: #lf."
]

{ #category : #saving }
OPAbstractSerializer >> saveMemento: aMemento to: aFolder [
	self saveModel: aMemento to: aFolder.
	self saveViewsOf: aMemento to: aFolder
]

{ #category : #saving }
OPAbstractSerializer >> saveModel: aMemento to: aFolder [
	(aFolder / 'model' , self modelExtension)
		ensureDelete;
		writeStreamDo: [ :stream | stream nextPutAll: (self serializeModel: aMemento model) ]
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> serializeDiagram: aDiagramMemento [
	"Serialize a memento returned by your controller to a string"
	^ self subclassResponsibility
]

{ #category : #convenience }
OPAbstractSerializer >> serializeMemento: aMemento [
	^ STON
		toStringPretty:
			(Dictionary
				with: #model -> (self serializeModel: aMemento model)
				with: #diagram -> (self serializeDiagram: aMemento diagram))
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> serializeModel: aModel [
	"serialize your model into a string"
	^ self subclassResponsibility
]

{ #category : #'serialize/materialize' }
OPAbstractSerializer >> serializeView: aDiagramView [
	^ self subclassResponsibility
]

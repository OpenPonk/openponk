"
I store a snapshot of a model/diagram.
I am passed onto PersistenceManager that handles in-image storing of me, and from there I am also passed onto Plugin's Importer/Exporter that handles the actual transformation to the target file format.
"
Class {
	#name : #OPPersistenceMemento,
	#superclass : #Object,
	#instVars : [
		'model',
		'diagrams'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPPersistenceMemento class >> model: aModel diagram: aDiagram [
	self
		deprecated: 'OP no longer has one diagram per model, use diagrams instead'
		
	"^ self new
		setModel: aModel diagram: aDiagram;
		yourself"
]

{ #category : #'instance creation' }
OPPersistenceMemento class >> model: aModel diagrams: diagramsCollection [
	^ self new
		setModel: aModel diagrams: diagramsCollection;
		yourself
]

{ #category : #accessing }
OPPersistenceMemento >> diagram [
	self
		deprecated: 'OP no longer has one diagram per model, use diagrams instead'.
	^ self diagrams first
]

{ #category : #accessing }
OPPersistenceMemento >> diagrams [
	^ diagrams
]

{ #category : #accessing }
OPPersistenceMemento >> model [
	^ model
]

{ #category : #initialization }
OPPersistenceMemento >> setModel: aModel diagram: aDiagram [
	self
		deprecated: 'OP no longer has one diagram per model, use views instead'

	"model := aModel.
	diagram := aDiagram"
]

{ #category : #initialization }
OPPersistenceMemento >> setModel: aModel diagrams: daigramsCollection [
	model := aModel.
	diagrams := daigramsCollection copy
]

{ #category : #accessing }
OPPersistenceMemento >> uuid [
	^ self model uuid
]

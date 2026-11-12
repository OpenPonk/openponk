"
Represents a snapshot of the application state (models and diagrams) used within the undo/redo mechanism.
Encapsulates the state at a specific point in time for later restoration.
"
Class {
	#name : 'OPMemento',
	#superclass : 'Object',
	#instVars : [
		'model',
		'diagrams'
	],
	#category : 'OpenPonk-Core-Persistence',
	#package : 'OpenPonk-Core',
	#tag : 'Persistence'
}

{ #category : 'instance creation' }
OPMemento class >> model: aModel diagrams: diagramsCollection [
	^ self new
		model: aModel;
		diagrams: diagramsCollection;
		yourself
]

{ #category : 'comparing' }
OPMemento >> = otherMemento [
	^ self model = otherMemento model
		and: [ self diagrams = otherMemento diagrams ]
]

{ #category : 'accessing' }
OPMemento >> diagrams [
	^ diagrams
]

{ #category : 'accessing' }
OPMemento >> diagrams: aDiagramsCollection [

	diagrams := aDiagramsCollection copy
]

{ #category : 'accessing' }
OPMemento >> model [
	^ model
]

{ #category : 'accessing' }
OPMemento >> model: aModel [
	model := aModel
]

{ #category : 'accessing' }
OPMemento >> uuid [
	^ self model uuid
]

"
I store a snapshot of a model/diagram.
I am passed onto PersistenceManager that handles in-image storing of me, and from there I am also passed onto Plugin's Importer/Exporter that handles the actual transformation to the target file format.
"
Class {
	#name : #OPPersistenceMemento,
	#superclass : #Object,
	#instVars : [
		'model',
		'diagram'
	],
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPPersistenceMemento class >> model: aModel diagram: aDiagram [
	^ self new
		setModel: aModel diagram: aDiagram;
		yourself
]

{ #category : #accessing }
OPPersistenceMemento >> diagram [
	^ diagram
]

{ #category : #accessing }
OPPersistenceMemento >> model [
	^ model
]

{ #category : #initialization }
OPPersistenceMemento >> setModel: aModel diagram: aDiagram [
	model := aModel.
	diagram := aDiagram
]

{ #category : #accessing }
OPPersistenceMemento >> uuid [
	^ self model uuid
]

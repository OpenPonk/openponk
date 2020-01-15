"
I store a snapshot of a model/diagram.
"
Class {
	#name : #OPAutosaveMemento,
	#superclass : #Object,
	#instVars : [
		'model',
		'diagram'
	],
	#category : 'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPAutosaveMemento class >> model: aModel diagram: aDiagram [
	^ self new
		model: aModel;
		diagram: aDiagram;
		yourself
]

{ #category : #accessing }
OPAutosaveMemento >> diagram [
	^ diagram
]

{ #category : #accessing }
OPAutosaveMemento >> diagram: aDiagramMemento [
	diagram := aDiagramMemento
]

{ #category : #accessing }
OPAutosaveMemento >> model [
	^ model
]

{ #category : #accessing }
OPAutosaveMemento >> model: aModel [
	model := aModel
]

{ #category : #accessing }
OPAutosaveMemento >> uuid [
	^ self model uuid
]

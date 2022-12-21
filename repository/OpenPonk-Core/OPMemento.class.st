Class {
	#name : #OPMemento,
	#superclass : #Object,
	#instVars : [
		'model',
		'diagrams'
	],
	#category : #'OpenPonk-Core-Persistence'
}

{ #category : #'instance creation' }
OPMemento class >> model: aModel diagram: aDiagram [
	self
		deprecated: 'OP no longer has one diagram per model, use diagrams instead'
		
	"^ self new
		setModel: aModel diagram: aDiagram;
		yourself"
]

{ #category : #'instance creation' }
OPMemento class >> model: aModel diagrams: diagramsCollection [
	^ self new
		model: aModel;
		diagrams: diagramsCollection;
		yourself
]

{ #category : #comparing }
OPMemento >> = otherMemento [
	^ self model = otherMemento model
		and: [ self diagrams = otherMemento diagrams ]
]

{ #category : #accessing }
OPMemento >> diagram [
	self
		deprecated: 'OP no longer has one diagram per model, use diagrams instead'.
	self diagrams ifEmpty: [ ^ nil ].
	^ self diagrams first
]

{ #category : #accessing }
OPMemento >> diagram: aDiagram [
	self
		deprecated: 'OP no longer has one diagram per model, use diagrams: instead'
		transformWith:
			'`@receiver diagram: `@statements1'
				-> '`@receiver diagrams: {`@statements1}'.
	diagrams := {aDiagram}
]

{ #category : #accessing }
OPMemento >> diagrams [
	^ diagrams
]

{ #category : #accessing }
OPMemento >> diagrams: aDiagramsCollection [
	diagrams := aDiagramsCollection copy
]

{ #category : #accessing }
OPMemento >> model [
	^ model
]

{ #category : #accessing }
OPMemento >> model: aModel [
	model := aModel
]

{ #category : #initialization }
OPMemento >> setModel: aModel diagram: aDiagram [
	self
		deprecated: 'OP no longer has one diagram per model, use views instead'
		transformWith:
			'`@receiver setModel: `@statements1 diagram: `@statements2'
				-> '`@receiver model: `@statements1; diagrams: {`@statements2}'

	"model := aModel.
	diagram := aDiagram"
]

{ #category : #initialization }
OPMemento >> setModel: aModel diagrams: diagramsCollection [

	self
		deprecated: 'set model and diagrams separately'
		transformWith:
			'`@receiver setModel: `@statements1 diagrams: `@statements2'
			-> '`@receiver model: `@statements1; diagrams: `@statements2'.
	^ self
		  model: aModel;
		  diagrams: diagramsCollection
]

{ #category : #accessing }
OPMemento >> uuid [
	^ self model uuid
]

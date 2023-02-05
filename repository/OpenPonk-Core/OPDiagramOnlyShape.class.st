Class {
	#name : #OPDiagramOnlyShape,
	#superclass : #OPShape,
	#instVars : [
		'uuid'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'ston-core' }
OPDiagramOnlyShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #uuid )
]

{ #category : #accessing }
OPDiagramOnlyShape >> announcer [

	^ roassalShape ifNotNil: #announcer
]

{ #category : #accessing }
OPDiagramOnlyShape >> initialize [

	super initialize.
	uuid := UUID new
]

{ #category : #accessing }
OPDiagramOnlyShape >> modelElements [

	^ { self }
]

{ #category : #accessing }
OPDiagramOnlyShape >> modelElements: aCollection [

	(aCollection noneSatisfy: [ :any | any ~= self ]) ifTrue: [ ^ self ].
	self shouldNotImplement
]

{ #category : #rendering }
OPDiagramOnlyShape >> updateRenderFromModel [

	^ self updateRenderFromSelf
]

{ #category : #accessing }
OPDiagramOnlyShape >> uuid [

	^ uuid
]

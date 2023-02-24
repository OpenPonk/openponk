Class {
	#name : #OPDiagram,
	#superclass : #OPShape,
	#instVars : [
		'name',
		'documentation',
		'resolution'
	],
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #'ston-core' }
OPDiagram class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name #documentation #resolution )
]

{ #category : #accessing }
OPDiagram >> documentation [

	^ documentation
]

{ #category : #accessing }
OPDiagram >> documentation: anObject [

	documentation := anObject
]

{ #category : #testing }
OPDiagram >> isRendered [

	^ roassalShape isNotNil
]

{ #category : #accessing }
OPDiagram >> name [

	^ name ifNil: [ self modelElement name ]
]

{ #category : #accessing }
OPDiagram >> name: anObject [

	name := anObject
]

{ #category : #'as yet unclassified' }
OPDiagram >> ownedElement: aShape renderedIn: aCanvas [

	self isRendered ifTrue: [ 
		self
			assert: roassalShape canvas = aCanvas
			description:
			'Reusing same diagram element for 2 canvases not allowed'.
		^ self owningElement ifNotNil: [ :owner | 
			  owner ownedElement: aShape renderedIn: aCanvas ] ].
	roassalShape := aCanvas.
	self updateRenderFromSelf
]

{ #category : #rendering }
OPDiagram >> renderBasicShape [

	"diagram cannot be rendered directly now, only its owned elements"

	^ nil
]

{ #category : #rendering }
OPDiagram >> renderBasicShapeIn: aCanvas [

	self isRendered ifTrue: [ 
		roassalShape canvas = aCanvas ifFalse: [ 
			self error:
				'Reusing same diagram element for 2 canvases not allowed' ] ]
]

{ #category : #accessing }
OPDiagram >> resolution [

	^ resolution
]

{ #category : #accessing }
OPDiagram >> resolution: anObject [

	resolution := anObject
]

{ #category : #'as yet unclassified' }
OPDiagram >> updateFromRender [

	self bounds: (OPDIBounds
			 withPosition: 0 @ 0
			 extent: roassalShape encompassingRectangle extent).
	self ownedElements do: #updateFromRender
]

{ #category : #'as yet unclassified' }
OPDiagram >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	self ownedElements do: #updateRenderFromSelf.
	roassalShape signalUpdate
]

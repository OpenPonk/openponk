Class {
	#name : 'OPDiagram',
	#superclass : 'OPBoundNode',
	#instVars : [
		'name',
		'documentation',
		'resolution'
	],
	#category : 'OpenPonk-Core-Shapes',
	#package : 'OpenPonk-Core',
	#tag : 'Shapes'
}

{ #category : 'ston-core' }
OPDiagram class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames , #( #name #documentation #resolution )
]

{ #category : 'as yet unclassified' }
OPDiagram >> canvas: aCanvas [

	self isRendered ifTrue: [
		self
			assert: roassalShape canvas = aCanvas
			description:
			'Reusing same diagram element for 2 canvases not allowed'.
		^ false ].
	roassalShape := aCanvas.
	^ true
]

{ #category : 'accessing' }
OPDiagram >> documentation [

	^ documentation
]

{ #category : 'accessing' }
OPDiagram >> documentation: anObject [

	documentation := anObject
]

{ #category : 'as yet unclassified' }
OPDiagram >> isPositionableByUser [

	^ false
]

{ #category : 'testing' }
OPDiagram >> isRendered [

	^ roassalShape isNotNil
]

{ #category : 'as yet unclassified' }
OPDiagram >> isResizableByUser [

	^ false
]

{ #category : 'as yet unclassified' }
OPDiagram >> modelElementName [

	^ (self modelElement respondsTo: #name)
		  ifTrue: [ self modelElement name ]
		  ifFalse: [ self modelElementType ]
]

{ #category : 'as yet unclassified' }
OPDiagram >> modelElementType [

	^ self modelElement className
]

{ #category : 'accessing' }
OPDiagram >> name [

	^ name ifNil: [ self modelElement name ]
]

{ #category : 'accessing' }
OPDiagram >> name: anObject [

	name := anObject
]

{ #category : 'as yet unclassified' }
OPDiagram >> ownedElement: aShape renderedIn: aCanvas [

	(self canvas: aCanvas) ifFalse: [ ^ self ].
	self updateRenderFromSelf
]

{ #category : 'rendering' }
OPDiagram >> renderBasicShape [

	"diagram cannot be rendered directly now, only its owned elements"

	^ nil
]

{ #category : 'rendering' }
OPDiagram >> renderBasicShapeIn: aCanvas [

	self isRendered ifTrue: [ 
		roassalShape canvas = aCanvas ifFalse: [ 
			self error:
				'Reusing same diagram element for 2 canvases not allowed' ] ]
]

{ #category : 'rendering' }
OPDiagram >> renderShapeDetails [
	"diagram cannot be rendered directly now, only its owned elements"

	^ nil
]

{ #category : 'accessing' }
OPDiagram >> resolution [

	^ resolution
]

{ #category : 'accessing' }
OPDiagram >> resolution: anObject [

	resolution := anObject
]

{ #category : 'as yet unclassified' }
OPDiagram >> updateFromRender [

	self bounds: (OPNodeBounds
			 withPosition: 0 @ 0
			 extent: roassalShape encompassingRectangle extent).
	self ownedElements do: #updateFromRender
]

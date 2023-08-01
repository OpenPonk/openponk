Class {
	#name : #OPRSSelectable,
	#superclass : #RSHighlightable,
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #announcer }
OPRSSelectable >> announceHighlight: shape source: shapeOrCanvas [

	(shape propertyAt: self class ifAbsent: [ ^ self ]) announce: [ 
		RSHighlightEvent new
			interaction: self;
			shape: shape;
			source: shapeOrCanvas ]
]

{ #category : #announcer }
OPRSSelectable >> announceUnHightlight: shape source: shapeOrCanvas [

	(shape propertyAt: self class ifAbsent: [ ^ self ]) announce: [ 
		RSUnHighlightEvent new
			interaction: self;
			shape: shape;
			source: shapeOrCanvas ]
]

{ #category : #'as yet unclassified' }
OPRSSelectable >> highlightAdornments: aBlock [
	"Show adornments (little icons with actions). The block receives an OPRSAdornmentBuilder"

	| builder |
	builder := OPRSAdornmentBuilder new.
	aBlock value: builder.

	self
		when: RSHighlightEvent
		do: [ :evt | builder showOn: evt shape ]
		for: self;
		when: RSUnHighlightEvent do: [ :evt | builder hide ] for: self
]

{ #category : #'as yet unclassified' }
OPRSSelectable >> highlightBorderColor: aColor [
	"Set the border color"

	self
		when: RSHighlightEvent do: [ :evt |
			self
				record: evt shape
				selector: #border
				value:
					((evt shape border ifNil: [ RSBorder new ] ifNotNil: #copy)
						 color: aColor;
						 yourself) ]
		for: self;
		when: RSUnHighlightEvent
		do: [ :evt | self restore: evt shape selector: #border ]
		for: self
]

{ #category : #hooks }
OPRSSelectable >> onShape: aShape [

	aShape propertyAt: self class put: self.
	aShape
		when: RSMouseLeftClick
		do: [ :evt |
			aShape canvas
				propertyAt: OPRSSelectableCanvas
				ifPresent: [ :selectableCanvasInteraction |
					| currentlySelectedShapes |
					currentlySelectedShapes := selectableCanvasInteraction
						                           selectedShapes.
					selectableCanvasInteraction
						selectShapes: (evt metaKeyPressed
								 ifTrue: [
									 (currentlySelectedShapes includes: aShape)
										 ifTrue: [
										 RSGroup withAll:
											 (currentlySelectedShapes copyWithout: aShape) ]
										 ifFalse: [
											 (RSGroup withAll: currentlySelectedShapes)
												 add: aShape;
												 yourself ] ]
								 ifFalse: [ RSGroup with: aShape ])
						byEvent: evt ]
				ifAbsent: [
					self error:
						'OPRSSelectable requires OPRSSelectableCanvas on canvas' ] ]
		for: self
]

{ #category : #accessing }
OPRSSelectable >> propertyKey [

	^ propertyKey ifNil: [ propertyKey := #selectedShapes ]
]

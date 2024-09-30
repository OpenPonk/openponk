Trait {
	#name : 'OPTResizableFigureWithText',
	#instVars : [
		'renderedWrapWidth',
		'renderedText',
		'labeled'
	],
	#category : 'OpenPonk-Core-CommonElements',
	#package : 'OpenPonk-Core',
	#tag : 'CommonElements'
}

{ #category : 'creating - subelements' }
OPTResizableFigureWithText >> renderLabel [

	labeled := OPRSLabeled new.
	labeled shapeBuilder wrapStrategy:
		(RSWrapStrategy new wrapMaxWidth: self wrapMaxWidth).
	labeled locationDo: [ :location | self setupLabelLocation: location ].
	self updateText.

	self roassalShape @ labeled.

	self roassalShape
		when: RSExtentChangedEvent
		do: [ self updateText ]
		for: self
]

{ #category : 'creating - subelements' }
OPTResizableFigureWithText >> renderShapeDetails [

	super renderShapeDetails.
	self renderLabel
]

{ #category : 'creating - subelements' }
OPTResizableFigureWithText >> setupLabelLocation: aLocation [

	aLocation
		middle;
		center;
		inner
]

{ #category : 'accessing' }
OPTResizableFigureWithText >> text [

	^ self shouldBeImplemented
]

{ #category : 'creating - subelements' }
OPTResizableFigureWithText >> textPadding [
	^ 8
]

{ #category : 'update' }
OPTResizableFigureWithText >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].

	self updateTextLabelContents.

	super updateRenderFromSelf
]

{ #category : 'update' }
OPTResizableFigureWithText >> updateText [

	self isRendered ifFalse: [ ^ self ].

	self updateTextLabelContents.

	self roassalShape signalUpdate
]

{ #category : 'update' }
OPTResizableFigureWithText >> updateTextLabelContents [

	labeled
		wrapMaxWidth: self wrapMaxWidth;
		text: self text
]

{ #category : 'hooks' }
OPTResizableFigureWithText >> wrapMaxWidth [

	^ self width - (self textPadding * 2) max: 20
]

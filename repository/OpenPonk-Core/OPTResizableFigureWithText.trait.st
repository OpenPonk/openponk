Trait {
	#name : #OPTResizableFigureWithText,
	#instVars : [
		'label'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #accessing }
OPTResizableFigureWithText >> label [
	^ label
]

{ #category : #'creating - subelements' }
OPTResizableFigureWithText >> removeRender [

	self label ifNotNil: #remove.
	super removeRender
]

{ #category : #'creating - subelements' }
OPTResizableFigureWithText >> renderLabel [

	| block |
	self flag: #multiline.
	label := RSLabel new
		         height: 10;
		         model: self;
		         yourself.
	self canvas add: label.
	block := [ self updateText ].
	block value.
	self roassalShape
		when: RSPositionChangedEvent do: block;
		when: RSExtentChangedEvent do: block
]

{ #category : #'creating - subelements' }
OPTResizableFigureWithText >> renderShapeDetails [

	self renderLabel
]

{ #category : #hooks }
OPTResizableFigureWithText >> text [
	^ self explicitRequirement
]

{ #category : #'creating - subelements' }
OPTResizableFigureWithText >> textOffset [
	^ 0 @ 0
]

{ #category : #'creating - subelements' }
OPTResizableFigureWithText >> textPadding [
	^ 8
]

{ #category : #update }
OPTResizableFigureWithText >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].

	self updateTextWithoutRedraw.

	super updateRenderFromSelf
]

{ #category : #update }
OPTResizableFigureWithText >> updateText [

	self isRendered ifFalse: [ ^ self ].

	self updateTextWithoutRedraw.

	self label signalUpdate
]

{ #category : #private }
OPTResizableFigureWithText >> updateTextWithoutRedraw [

	self label width: self width - (self textPadding * 2).
	self label text: self text.
	self label translateTo: self position + self textOffset
]

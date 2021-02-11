Class {
	#name : #OPResizableFigureWithText,
	#superclass : #RTAbstractMultiElement,
	#instVars : [
		'text'
	],
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #rendering }
OPResizableFigureWithText >> addInteractions [
	self @ RTResizable
]

{ #category : #'creating - subelements' }
OPResizableFigureWithText >> createOwnedElements [
	| block |
	text := RTText new
		fontSize: 10;
		text: [ :m | m model ifNil: '' ifNotNil: self modelTextSelector ];
		wrapText;
		elementOn: self.
	self add: text.
	block := [ self updateText ].
	block value.
	self addCallback: (TRTranslationCallback block: block).
	self addCallback: (TRExtentCallback block: block)
]

{ #category : #hooks }
OPResizableFigureWithText >> modelTextSelector [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPResizableFigureWithText >> text [
	^ text
]

{ #category : #'creating - subelements' }
OPResizableFigureWithText >> textOffset [
	^ 0 @ 0
]

{ #category : #'creating - subelements' }
OPResizableFigureWithText >> textPadding [
	^ 8
]

{ #category : #update }
OPResizableFigureWithText >> updateText [
	text shape width: self width - (self textPadding * 2).
	text update.
	text translateTo: self position + self textOffset
]

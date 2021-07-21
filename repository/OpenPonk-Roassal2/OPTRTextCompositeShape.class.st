Class {
	#name : #OPTRTextCompositeShape,
	#superclass : #TRCompositeShape,
	#category : #'OpenPonk-Roassal2-Interactivity'
}

{ #category : #accessing }
OPTRTextCompositeShape >> color: aColor [
	self allColor: aColor
]

{ #category : #accessing }
OPTRTextCompositeShape >> fontSize [
	self shapes ifEmpty: [ ^ TRLabelShape defaultFontSize ].
	^ self firstShape fontSize
]

{ #category : #accessing }
OPTRTextCompositeShape >> fontSize: aNumber [
	self shapesDo: [ :each | each fontSize: aNumber ]
]

{ #category : #accessing }
OPTRTextCompositeShape >> text [
	^ String
		streamContents: [ :s | self shapesDo: [ :each | s << each text ] ]
]

{ #category : #accessing }
OPTRTextCompositeShape >> text: aString [
	| txt lines currentColor fontSize |
	txt := aString copyReplaceAll: String tab with: '    '.
	lines := txt lines.
	lines ifEmpty: [ lines := Array with: '' ].
	shapeAndOffsets size - lines size
		timesRepeat: [ shapeAndOffsets last remove.
			self removeLast ].
	currentColor := shapeAndOffsets
		ifEmpty: [ nil ]
		ifNotEmpty: [ self firstShape color ].
	fontSize := shapeAndOffsets
		ifEmpty: [ nil ]
		ifNotEmpty: [ self firstShape fontSize ].
	shapeAndOffsets size + 1 to: lines size do: [ :index | 
		| newShape |
		newShape := TRLabelShape new
			color: currentColor;
			fontSize: fontSize;
			element: self element;
			yourself.
		self
			addShape: newShape
			translateBy:
				(index = 1
					ifTrue: [ 0 @ 0 ]
					ifFalse: [ 0 @ (self firstShape height * (index - 1)) ]).
		self firstShape canvas
			ifNotNil: [ newShape addedIn: self firstShape canvas ] ].
	1 to: lines size do: [ :each | (shapeAndOffsets at: each) first text: (lines at: each) ].
	self resetInnerShapes.
	self relayout
]

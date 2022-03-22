Class {
	#name : #OPRTStyledMultilineLabel,
	#superclass : #RTStyledLabel,
	#instVars : [
		'fixedWidth'
	],
	#category : #'OpenPonk-Roassal2-Shapes'
}

{ #category : #accessing }
OPRTStyledMultilineLabel >> fontSize: aSize [
	^ self height: aSize
]

{ #category : #rendering }
OPRTStyledMultilineLabel >> textFor: anElement [
	^ (super textFor: anElement) , ' '
]

{ #category : #hooks }
OPRTStyledMultilineLabel >> trachelShapeFor: anElement [

	^ self trachelShapeForMultiLine: anElement
]

{ #category : #'trachel shape production' }
OPRTStyledMultilineLabel >> trachelShapeForMultiLine: anElement [

	| colorForElement fontSizeForElement textForElement emphasisForElement fontNameForElement lines shape |
	colorForElement := self colorFor: anElement.
	fontSizeForElement := self heightFor: anElement.
	textForElement := self wrappedTextFor: anElement.
	emphasisForElement := self emphasisFor: anElement.
	fontNameForElement := self fontNameFor: anElement.

	textForElement := textForElement
		                  copyReplaceAll: String tab
		                  with: '    '.
	lines := textForElement lines.

	shape := TRCompositeShape new.
	lines doWithIndex: [ :l :index | 
		| lbl |
		lbl := TRStyledLabelShape new.
		lbl
			color: colorForElement;
			fontSize: fontSizeForElement;
			emphasis: emphasisForElement;
			fontName: fontNameForElement;
			text: l.
		shape addShape: lbl ].
	shape verticalAndLeft.

	^ shape
]

{ #category : #'trachel shape production' }
OPRTStyledMultilineLabel >> updateFor: anElement trachelShape: trachelShape [

	| lines colorForElement fontSizeForElement textForElement emphasisForElement fontNameForElement |
	colorForElement := self colorFor: anElement.
	fontSizeForElement := self heightFor: anElement.
	textForElement := self wrappedTextFor: anElement.
	emphasisForElement := self emphasisFor: anElement.
	fontNameForElement := self fontNameFor: anElement.
	textForElement := textForElement
		                  copyReplaceAll: String tab
		                  with: '    '.
	lines := textForElement lines.

	trachelShape numberOfShapes > lines size ifTrue: [ 
		trachelShape numberOfShapes - lines size timesRepeat: [ 
			trachelShape shapes last remove.
			trachelShape removeLast ] ].
	lines size > trachelShape numberOfShapes ifTrue: [ 
		lines size - trachelShape numberOfShapes timesRepeat: [ 
			| shape |
			shape := TRStyledLabelShape new.
			shape element: anElement.
			trachelShape canvas ifNotNil: [ :canvas | canvas addShape: shape ].
			trachelShape addShape: shape ].
		trachelShape positionShapesAfterBeingAdded ].

	lines doWithIndex: [ :l :index | 
		(trachelShape shapes at: index)
			fontSize: fontSizeForElement;
			color: colorForElement;
			emphasis: emphasisForElement;
			fontName: fontNameForElement;
			text: l ].

	trachelShape verticalAndLeftWithoutReset.
	^ trachelShape
]

{ #category : #rendering }
OPRTStyledMultilineLabel >> width: aNumber [
	fixedWidth := aNumber
]

{ #category : #rendering }
OPRTStyledMultilineLabel >> widthFor: anElement [

	| lines txt |
	fixedWidth ifNotNil: [ ^ fixedWidth ].
	txt := self textFor: anElement.
	txt := txt copyReplaceAll: String tab with: '    '.
	lines := txt lines.
	lines ifEmpty: [ ^ 0 ].
	^ lines max: [ :each | 
		  TRStyledLabelShape
			  widthOfText: each
			  fontName: (self fontNameFor: fontName)
			  fontSize: (self heightFor: anElement)
			  emphasis: (self emphasisFor: anElement) ]
]

{ #category : #wrapping }
OPRTStyledMultilineLabel >> wrappedTextFor: anElement [

	"This is a naive brute-force implementation of line-wrapping algorithm.

	There is also TxAthensCharacterWrappingStrategy that is more advanced, but requires the use of 	TxModel/Spans, etc."

	| words lineWidth lines line ww textForElement fontForElement heightForElement widthForElement |
	fixedWidth ifNil: [ ^ self textFor: anElement ].
	textForElement := self textFor: anElement.
	fontForElement := self fontNameFor: anElement.
	heightForElement := self heightFor: anElement.
	widthForElement := self widthFor: anElement.
	words := textForElement splitOn: ' '.
	lineWidth := 0.
	lines := OrderedCollection new.
	line := OrderedCollection new.
	lines add: line.
	words do: [ :word | 
		| wordsByManualLines |
		wordsByManualLines := word splitOn: Character cr.
		ww := TRStyledLabelShape
			      widthOfText: wordsByManualLines first
			      fontName: fontForElement
			      fontSize: heightForElement
			      emphasis: emphasis.
		lineWidth = 0 ifFalse: [ 
			ww + lineWidth > widthForElement ifTrue: [ 
				lineWidth := 0.
				line := OrderedCollection new.
				lines add: line ] ].
		line add: wordsByManualLines first.
		wordsByManualLines copyWithoutFirst do: [ :eachWord | 
			lineWidth := 0.
			line := OrderedCollection with: eachWord.
			lines add: line.
			ww := TRStyledLabelShape
				      widthOfText: eachWord
				      fontName: fontForElement
				      fontSize: heightForElement
				      emphasis: emphasis ].
		lineWidth := lineWidth + ww ].
	^ (lines collect: [ :each | each joinUsing: ' ' ]) joinUsing:
		  String cr
]

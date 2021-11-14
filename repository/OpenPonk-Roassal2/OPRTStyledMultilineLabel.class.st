Class {
	#name : #OPRTStyledMultilineLabel,
	#superclass : #RTStyledLabel,
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

	| colorForElement fontSizeForElement textForElement emphasisForElement fontNameForElement txt lines shape |
	colorForElement := self colorFor: anElement.
	fontSizeForElement := self heightFor: anElement.
	textForElement := self textFor: anElement.
	emphasisForElement := self emphasisFor: anElement.
	fontNameForElement := self fontNameFor: anElement.

	txt := self textFor: anElement.
	txt := txt copyReplaceAll: String tab with: '    '.
	lines := txt lines.

	shape := TRCompositeShape new.
	lines doWithIndex: [ :l :index | 
		| lbl |
		lbl := TRStyledLabelShape new.
		lbl
			text: l;
			color: colorForElement;
			fontSize: fontSizeForElement;
			emphasis: emphasisForElement;
			fontName: fontNameForElement.
		shape addShape: lbl ].
	shape verticalAndLeft.

	^ shape
]

{ #category : #'trachel shape production' }
OPRTStyledMultilineLabel >> updateFor: anElement trachelShape: trachelShape [

	| lines colorForElement fontSizeForElement textForElement emphasisForElement fontNameForElement |
	colorForElement := self colorFor: anElement.
	fontSizeForElement := self heightFor: anElement.
	textForElement := self textFor: anElement.
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
			trachelShape canvas addShape: shape.
			trachelShape addShape: shape ].
		trachelShape positionShapesAfterBeingAdded ].
	lines doWithIndex: [ :l :index | 
		(trachelShape shapes at: index)
			text: l;
			color: colorForElement;
			fontSize: fontSizeForElement;
			emphasis: emphasisForElement;
			fontName: fontNameForElement ].
	trachelShape verticalAndLeftWithoutReset.
	^ trachelShape
]

{ #category : #rendering }
OPRTStyledMultilineLabel >> widthFor: anElement [
	| lines txt |
	txt := self textFor: anElement.
	txt := txt copyReplaceAll: String tab with: '    '.
	lines := txt lines.
	lines ifEmpty: [ ^ 0 ].
	^ lines
		max: [ :each | 
			TRStyledLabelShape
				widthOfText: each
				fontName: (self fontNameFor: fontName)
				fontSize: (self heightFor: anElement)
				emphasis: (self emphasisFor: anElement) ]
]

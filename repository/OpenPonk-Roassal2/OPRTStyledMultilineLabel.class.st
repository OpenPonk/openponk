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
OPRTStyledMultilineLabel >> updateFor: anElement trachelShape: trachelShape [
	| lines lbl txt aColor fontSize |
	aColor := self colorFor: anElement.
	fontSize := self heightFor: anElement.
	txt := self textFor: anElement.
	txt := txt copyReplaceAll: String tab with: '    '.
	lines := txt lines.
	trachelShape numberOfShapes > lines size
		ifTrue: [ trachelShape numberOfShapes - lines size
				timesRepeat: [ trachelShape shapes last remove.
					trachelShape removeLast ] ].
	lines size > trachelShape numberOfShapes
		ifTrue: [ lines size - trachelShape numberOfShapes
				timesRepeat: [ | shape |
					shape := TRLabelShape new.
					shape element: anElement.
					trachelShape canvas addShape: shape.
					trachelShape addShape: shape ].
			trachelShape positionShapesAfterBeingAdded ].
	lines
		doWithIndex: [ :l :index | 
			lbl := (trachelShape shapes at: index) text: l.
			lbl color: aColor.
			lbl fontSize: fontSize ].
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

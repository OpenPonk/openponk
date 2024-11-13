Class {
	#name : 'OPAbstractLabelTest',
	#superclass : 'OPAbstractNodeTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'hooks' }
OPAbstractLabelTest >> shapeClass [
	^ OPTestLabel
]

{ #category : 'tests' }
OPAbstractLabelTest >> testRoassalShape [

	| roassalShape |
	shape text: 'some text'.
	shape renderIn: RSCanvas new.
	roassalShape := shape roassalShape.
	self assert: roassalShape class equals: RSLabel.
	self assert: roassalShape text equals: 'some text'
]

{ #category : 'tests' }
OPAbstractLabelTest >> testRoassalShapeEmphasis [

	| roassalShape |
	shape text: 'some text'.
	shape localStyle: OPOpenPonkShapeStyle new.
	shape renderIn: RSCanvas new.
	roassalShape := shape roassalShape.
	self assert: roassalShape emphasis equals: TextEmphasis normal.

	shape localStyle fontBold: true.
	self assert: roassalShape emphasis equals: TextEmphasis bold.

	shape localStyle fontUnderline: true.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 yourself).

	shape localStyle fontItalic: true.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 add: TextEmphasis italic;
			 yourself)
]

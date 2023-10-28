Class {
	#name : #OPLabelTest,
	#superclass : #OPDiagramElementTestCase,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #tests }
OPLabelTest >> elementClass [
	^ OPLabel
]

{ #category : #tests }
OPLabelTest >> testRoassalShape [

	| roassalShape |
	element text: 'some text'.
	element renderIn: RSCanvas new.
	roassalShape := element roassalShape.
	self assert: roassalShape class equals: RSLabel.
	self assert: roassalShape text equals: 'some text'
]

{ #category : #tests }
OPLabelTest >> testRoassalShapeEmphasis [

	| roassalShape |
	element text: 'some text'.
	element localStyle: OPOpenPonkShapeStyle new.
	element renderIn: RSCanvas new.
	roassalShape := element roassalShape.
	self assert: roassalShape emphasis equals: TextEmphasis normal.

	element localStyle fontBold: true.
	self assert: roassalShape emphasis equals: TextEmphasis bold.

	element localStyle fontUnderline: true.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 yourself).

	element localStyle fontItalic: true.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 add: TextEmphasis italic;
			 yourself)
]

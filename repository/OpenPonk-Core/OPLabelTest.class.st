Class {
	#name : #OPLabelTest,
	#superclass : #OPDiagramElementTestCase,
	#category : #'OpenPonk-Core-Tests'
}

{ #category : #tests }
OPLabelTest >> elementClass [
	^ OPUmlLabel
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
	element localStyle: OPDIOpenPonkStyle new.
	element renderIn: RSCanvas new.
	roassalShape := element roassalShape.
	self assert: roassalShape emphasis equals: TextEmphasis normal.

	element localStyle fontBold: true.
	element updateRenderFromSelf.
	self assert: roassalShape emphasis equals: TextEmphasis bold.

	element localStyle fontUnderline: true.
	element updateRenderFromSelf.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 yourself).

	element localStyle fontItalic: true.
	element updateRenderFromSelf.
	self assert: roassalShape emphasis equals: (TextEmphasis bold
			 add: TextEmphasis underlined;
			 add: TextEmphasis italic;
			 yourself)
]

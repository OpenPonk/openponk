"
Verifies label styling, text updates, and labelShape access in OPRSLabeled.
"
Class {
	#name : 'OPRSLabeledTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'tests' }
OPRSLabeledTest >> testConfigureColorEmphasisFontNameAndAccessLabelShape [

	| canvas box labeled |
	canvas := RSCanvas new.
	box := RSBox new
		       size: 80;
		       yourself.
	canvas add: box.
	labeled := OPRSLabeled new.
	labeled
		color: Color red;
		emphasis: TextEmphasis bold;
		fontName: 'Source Sans Pro';
		text: 'Sample'.
	box @ labeled.
	self assert: labeled labelShape color equals: Color red.
	self assert: labeled labelShape emphasis equals: TextEmphasis bold.
	self assert: labeled labelShape fontName equals: 'Source Sans Pro'.
	self assert: labeled labelShape text equals: 'Sample'
]

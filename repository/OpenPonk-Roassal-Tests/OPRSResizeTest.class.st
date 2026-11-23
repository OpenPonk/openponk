"
Verifies oversize defaults and automatic biggest-shape selection in OPRSResize.
"
Class {
	#name : 'OPRSResizeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'tests' }
OPRSResizeTest >> testDefaultOversizeAndSameSizeUsesBiggestShape [

	| smallBox bigBox resize |
	smallBox := RSBox new
		            extent: 30 @ 20;
		            yourself.
	bigBox := RSBox new
		          extent: 80 @ 50;
		          yourself.
	resize := OPRSResize new.
	self assert: resize oversize equals: 0 @ 0.
	resize
		shapes: {
				smallBox.
				bigBox };
		sameSize.
	self assert: smallBox extent equals: 80 @ 50.
	self assert: bigBox extent equals: 80 @ 50
]

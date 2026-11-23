"
Verifies custom scale and padding camera positioning calculations for Roassal canvas exports.
"
Class {
	#name : 'OPRSCustomScaleCamSetterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Exports',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Exports'
}

{ #category : 'tests' }
OPRSCustomScaleCamSetterTest >> testCustomScaleAndPaddingAffectExtentAndCamera [

	| canvas box setter |
	canvas := RSCanvas new.
	box := RSBox new
		       extent: 100 @ 50;
		       translateTo: 50 @ 25;
		       yourself.
	canvas add: box.

	setter := OPRSCustomScaleCamSetter scale: 2.
	setter canvas: canvas.
	self assert: setter scale equals: 2.
	self assert: setter padding equals: 25.
	self assert: setter extent equals: 225 @ 125.

	setter padding: 10.
	self assert: setter padding equals: 10.
	self assert: setter extent equals: 210 @ 110.

	setter setCamera.
	self assert: canvas camera scale equals: 2
]

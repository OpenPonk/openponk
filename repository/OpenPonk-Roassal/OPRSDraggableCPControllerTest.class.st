Class {
	#name : 'OPRSDraggableCPControllerTest',
	#superclass : 'TestCase',
	#instVars : [
		'controller',
		'boxFrom',
		'selfLine'
	],
	#category : 'OpenPonk-Roassal-Tests',
	#package : 'OpenPonk-Roassal',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRSDraggableCPControllerTest >> setUp [

	super setUp.

	boxFrom := RSBox new.
	selfLine := RSPolyline new.
	controller := OPRSDraggableCPController new.
	selfLine controlPointsController: controller.
	selfLine
		from: boxFrom;
		to: boxFrom
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testSelfLoopInitial [

	selfLine update.
	self assert: selfLine controlPoints size equals: 5
]

{ #category : 'tests' }
OPRSDraggableCPControllerTest >> testSelfLoopPreset [

	selfLine controlPoints: {
			boxFrom encompassingRectangle topCenter.
			(boxFrom encompassingRectangle topCenter - (0 @ 100)).
			(boxFrom encompassingRectangle rightCenter + (100 @ 0)).
			boxFrom encompassingRectangle rightCenter }.
	selfLine update.
	self assert: selfLine controlPoints size equals: 4
]

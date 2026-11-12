"
Verifies adornment creation, positioning around shapes, click handling, and cleanup when hidden or when target shape is removed.
"
Class {
	#name : 'OPRSAdornmentTest',
	#superclass : 'TestCase',
	#instVars : [
		'targetShape'
	],
	#category : 'OpenPonk-Roassal-Tests-Interactions',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Interactions'
}

{ #category : 'running' }
OPRSAdornmentTest >> setUp [
	super setUp.
	targetShape := RSBox new
		extent: 40 @ 30;
		translateTo: 100 @ 100;
		yourself.
	RSCanvas new add: targetShape
]

{ #category : 'tests' }
OPRSAdornmentTest >> testAdornmentBuilderShowsUpdatesAndHidesAdornments [
	| builder clicked iconShape adornment |
	clicked := false.
	iconShape := RSBox new size: 8; yourself.
	builder := OPRSAdornmentBuilder new.
	builder
		directionLeft;
		directionRight;
		directionUp;
		directionDown;
		addIconShape: iconShape action: [ clicked := true ];
		addIconForm: (Form extent: 8 @ 8 depth: 32) action: [ clicked := true ].
	builder showOn: targetShape.
	adornment := (builder instVarNamed: #adornments) first.
	self
		assert: adornment shape isInACanvas
		description: 'Adornment shape should be added to canvas when shown'.
	self
		assert: adornment icon isInACanvas
		description: 'Adornment icon should be added to canvas when shown'.
	adornment shape announce: RSMouseLeftClick new.
	self
		assert: clicked
		description: 'Clicking adornment shape should trigger its configured action block'.
	targetShape translateTo: 150 @ 120.
	self
		assert: adornment shape position x > 150
		description: 'Adornment shape should follow translated target shape'.
	builder hide.
	self
		deny: adornment shape isInACanvas
		description: 'Adornment shape should be removed from canvas when hidden'.
	self
		deny: adornment icon isInACanvas
		description: 'Adornment icon should be removed from canvas when hidden'
]

{ #category : 'tests' }
OPRSAdornmentTest >> testRemovingTargetShapeRemovesAdornment [
	| adornment |
	adornment := OPRSAdornment new.
	adornment padding: 4.
	adornment
		showOnShape: targetShape
		horizontal: RSLocation new outer right
		vertical: RSLocation new inner top
		offset: 0 @ 0.
	self
		assert: adornment shape isInACanvas
		description: 'Adornment shape should be in canvas after showOnShape:'.
	targetShape remove.
	self
		deny: adornment shape isInACanvas
		description: 'Removing target shape from canvas should automatically remove adornment shape'
]

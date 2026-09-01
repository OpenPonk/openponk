"
Custom Roassal control configuration extending standard canvas interactions to support OpenPonk-specific behaviors like drag snapping, alignment margins, and camera constraints.
"
Class {
	#name : 'OPRSControlConfiguration',
	#superclass : 'RSControlConfiguration',
	#instVars : [
		'keepCameraOnContent',
		'dragSnapComparisonsAmount',
		'dragSnapMargin'
	],
	#classInstVars : [
		'keepCameraOnContent',
		'dragAttachmentMargin',
		'dragSnapComparisonsAmount'
	],
	#category : 'OpenPonk-Roassal-Interactions',
	#package : 'OpenPonk-Roassal',
	#tag : 'Interactions'
}

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapComparisonsAmount [

	^ dragSnapComparisonsAmount ifNil: [
		  self dragSnapComparisonsAmountDefault ]
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapComparisonsAmount: anInteger [

	self assert: anInteger isInteger.
	self assert: anInteger >= 0.
	dragSnapComparisonsAmount := anInteger
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapComparisonsAmountDefault [

	^ 10
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapMargin [

	^ dragAttachmentMargin ifNil: [ self dragSnapMarginDefault ]
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapMargin: aNumber [

	self assert: aNumber >= 0.
	dragAttachmentMargin := aNumber
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> dragSnapMarginDefault [

	^ 5
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> keepCameraOnContent [

	^ keepCameraOnContent ifNil: [ false ]
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> keepCameraOnContent: aBoolean [

	keepCameraOnContent := aBoolean
]

{ #category : 'accessing' }
OPRSControlConfiguration class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #keepCameraOnContent)
		parent: #openponk;
		target: self;
		label: 'Prevent moving away from canvas content';
		description:
			'When enabled, canvas tries to limit you from zooming/dragging away from area with existing shapes, so at least part of the existing diagram is usually always seen. Only affects newly displayed diagrams.';
		order: 60.

	(aBuilder setting: #dragSnapComparisonsAmount)
		parent: #openponk;
		target: self;
		label: 'Shapes checked for drag snapping';
		description:
			'When dragging a shape, it is compared to this amount of closes shape in order to try to snap to it horizontally or vertically. The more amount of shapes, the more distant ones is it compared to and the slower dragging gets. Use 0 to turn the attaching feature off.';
		order: 71;
		default: self dragSnapComparisonsAmountDefault.
	(aBuilder setting: #dragSnapMargin)
		parent: #openponk;
		target: self;
		label: 'Margin for drag snapping';
		description:
			'When dragging a shape, it snaps to a horizontally or vertically aligned shapes within this margin, ie. in case of horizontal snapping, how much below of above the shapes can be to still snap to it.';
		order: 72;
		default: self dragSnapMarginDefault
]

{ #category : 'accessing' }
OPRSControlConfiguration >> dragSnapComparisonsAmount [

	^ dragSnapComparisonsAmount ifNil: [ self class dragSnapComparisonsAmount ]
]

{ #category : 'accessing' }
OPRSControlConfiguration >> dragSnapComparisonsAmount: anInteger [

	dragSnapComparisonsAmount := anInteger
]

{ #category : 'accessing' }
OPRSControlConfiguration >> dragSnapMargin [

	^ dragSnapMargin ifNil: [ self class dragSnapMargin ]
]

{ #category : 'accessing' }
OPRSControlConfiguration >> dragSnapMargin: aNumber [

	dragSnapMargin := aNumber
]

{ #category : 'accessing' }
OPRSControlConfiguration >> keepCameraOnContent [

	^ keepCameraOnContent ifNil: [ self class keepCameraOnContent ]
]

{ #category : 'accessing' }
OPRSControlConfiguration >> keepCameraOnContent: aBoolean [

	keepCameraOnContent := aBoolean
]

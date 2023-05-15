Class {
	#name : #OPRSControlConfiguration,
	#superclass : #RSControlConfiguration,
	#instVars : [
		'hasZoomableAnimation',
		'keepCameraOnContent',
		'dragAttachmentComparisonsAmount',
		'dragAttachmentMargin'
	],
	#classInstVars : [
		'keepCameraOnContent',
		'dragAttachmentMargin',
		'dragAttachmentComparisonsAmount'
	],
	#category : #'OpenPonk-Roassal3-Interactions'
}

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentComparisonsAmount [

	^ dragAttachmentComparisonsAmount ifNil: [
		  self dragAttachmentComparisonsAmountDefault ]
]

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentComparisonsAmount: anInteger [

	self assert: anInteger isInteger.
	self assert: anInteger >= 0.
	dragAttachmentComparisonsAmount := anInteger
]

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentComparisonsAmountDefault [

	^ 10
]

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentMargin [

	^ dragAttachmentMargin ifNil: [ self dragAttachmentMarginDefault ]
]

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentMargin: aNumber [

	self assert: aNumber >= 0.
	dragAttachmentMargin := aNumber
]

{ #category : #accessing }
OPRSControlConfiguration class >> dragAttachmentMarginDefault [

	^ 5
]

{ #category : #accessing }
OPRSControlConfiguration class >> keepCameraOnContent [

	^ keepCameraOnContent ifNil: [ true ]
]

{ #category : #accessing }
OPRSControlConfiguration class >> keepCameraOnContent: aBoolean [

	keepCameraOnContent := aBoolean
]

{ #category : #settings }
OPRSControlConfiguration class >> settingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #keepCameraOnContent)
		parent: #openponk;
		target: self;
		label: 'Prevent moving away from canvas content';
		description:
			'When enabled, canvas tries to limit you from zooming/dragging away from area with existing shapes, so at least part of the existing diagram is usually always seen. Only affects newly displayed diagrams.';
		order: 60.

	(aBuilder setting: #dragAttachmentComparisonsAmount)
		parent: #openponk;
		target: self;
		label: 'Shapes checked for dragging attachments';
		description:
			'When dragging a shape, it is compared to this amount of closes shape in order to try to attach to it horizontally or vertically. The more amount of shapes, the more distant ones is it compared to and the slower dragging gets. Use 0 to turn the attaching feature off.';
		order: 71;
		default: self dragAttachmentComparisonsAmountDefault.
	(aBuilder setting: #dragAttachmentMargin)
		parent: #openponk;
		target: self;
		label: 'Margin for dragging attachments';
		description:
			'When dragging a shape, it attaches to a horizontally or vertically aligned shapes within this margin, ie. in case of horizontal attachment, how much below of above the shapes can be to still attach.';
		order: 72;
		default: self dragAttachmentMarginDefault
]

{ #category : #accessing }
OPRSControlConfiguration >> dragAttachmentComparisonsAmount [

	^ dragAttachmentComparisonsAmount ifNil: [ self class dragAttachmentComparisonsAmount ]
]

{ #category : #accessing }
OPRSControlConfiguration >> dragAttachmentComparisonsAmount: anObject [

	dragAttachmentComparisonsAmount := anObject
]

{ #category : #accessing }
OPRSControlConfiguration >> dragAttachmentMargin [

	^ dragAttachmentMargin ifNil: [ self class dragAttachmentMargin ]
]

{ #category : #accessing }
OPRSControlConfiguration >> dragAttachmentMargin: anObject [

	dragAttachmentMargin := anObject
]

{ #category : #accessing }
OPRSControlConfiguration >> hasZoomableAnimation [

	^ hasZoomableAnimation ifNil: [ true ]
]

{ #category : #accessing }
OPRSControlConfiguration >> hasZoomableAnimation: anObject [

	hasZoomableAnimation := anObject
]

{ #category : #accessing }
OPRSControlConfiguration >> keepCameraOnContent [

	^ keepCameraOnContent ifNil: [ self class keepCameraOnContent ]
]

{ #category : #accessing }
OPRSControlConfiguration >> keepCameraOnContent: anObject [

	keepCameraOnContent := anObject
]

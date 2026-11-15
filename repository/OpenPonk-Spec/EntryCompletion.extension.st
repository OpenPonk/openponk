Extension { #name : 'EntryCompletion' }

{ #category : '*OpenPonk-Spec' }
EntryCompletion >> clampChooserContentHeightTo: aContentHeight [

	self flag: 'fixes cases with not enough space below'.
	
	chooser scrollPane clipSubmorphs: true.
	chooser forcesHeight: aContentHeight.
	chooser fullBounds
]

{ #category : '*OpenPonk-Spec' }
EntryCompletion >> ensureChooserFitsAllowedAreaRelativeTo: aFieldMorph [

	| allowedArea chooserFullBounds verticalBorder availableBelow anchorBottom availableAbove |
	self flag: 'fixes cases with not enough space below'.
	
	allowedArea := chooser allowedArea.
	chooserFullBounds := chooser fullBounds.
	chooserFullBounds bottom <= allowedArea bottom ifTrue: [ ^ self ].

	verticalBorder := chooser borderWidth * 2.
	availableBelow := allowedArea bottom - (chooserFullBounds top + verticalBorder).
	anchorBottom := aFieldMorph boundsInWorld topLeft y min: allowedArea bottom.
	availableAbove := anchorBottom - allowedArea top - verticalBorder.

	(availableBelow <= 0 and: [ availableAbove <= 0 ]) ifTrue: [
			self closeChooser.
			^ self ].

	(availableAbove > availableBelow and: [ availableBelow <= 0 or: [ availableBelow < self minimumChooserContentHeight ] ])
		ifTrue: [ self positionChooserAbove: aFieldMorph anchorBottom: anchorBottom availableHeight: availableAbove ]
		ifFalse: [ self clampChooserContentHeightTo: availableBelow ]
]

{ #category : '*OpenPonk-Spec' }
EntryCompletion >> minimumChooserContentHeight [

	| menus firstMenu |
	self flag: 'fixes cases with not enough space below'.

	menus := chooser choiceMenus.
	(menus isNil or: [ menus isEmpty ]) ifTrue: [ ^ 0 ].
	firstMenu := menus first.
	firstMenu submorphs ifEmpty: [ ^ 0 ].
	^ firstMenu submorphs first fullBounds height
]

{ #category : '*OpenPonk-Spec' }
EntryCompletion >> openChooserWith: aToken from: aFieldMorph [

	self flag: 'Fixes chooser to open in wrong position (relative to wrong morph)'.
	self closeChooser.
	self chooserWith: aToken.
	chooser ifNotNil: [
			| baseColor |
			baseColor := aFieldMorph window
				             ifNil: [ aFieldMorph color veryMuchLighter ]
				             ifNotNil: [ :aWindow | aWindow paneColor veryMuchLighter ].
			chooser baseColor: baseColor.
			chooser oneMenuOfWidth: aFieldMorph bounds width - aFieldMorph layoutInset - (aFieldMorph borderWidth * 2) - 2.
			chooser fillStyle: (aFieldMorph theme textEditorNormalFillStyleFor: aFieldMorph).
			chooser requestor: aFieldMorph.
			chooser position: aFieldMorph boundsInWorld bottomLeft + (aFieldMorph borderWidth @ 0).
			chooser open.
			self ensureChooserFitsAllowedAreaRelativeTo: aFieldMorph ].
	^ chooser
]

{ #category : '*OpenPonk-Spec' }
EntryCompletion >> positionChooserAbove: aFieldMorph anchorBottom: anAnchorBottom availableHeight: anAvailableHeight [

	| verticalBorder targetLeft |
	self flag: 'fixes cases with not enough space below'.
	
	verticalBorder := chooser borderWidth * 2.
	chooser fullBounds height > (anAvailableHeight + verticalBorder) ifTrue: [ self clampChooserContentHeightTo: anAvailableHeight ].
	targetLeft := aFieldMorph boundsInWorld topLeft x + aFieldMorph borderWidth.
	chooser position: targetLeft @ (anAnchorBottom - chooser fullBounds height).
	chooser fullBounds
]

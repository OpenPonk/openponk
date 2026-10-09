Extension { #name : 'EntryCompletion' }

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
			chooser boundsInWorld bottomLeft y > chooser allowedArea bottom ifTrue: [
				chooser forcesHeight: chooser allowedArea bottom - (chooser boundsInWorld topLeft y + 2) ].
			chooser open ].
	^ chooser
]

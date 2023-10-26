Trait {
	#name : #OPTDIColoredAsFillAndBorderColoredAsStroke,
	#traits : 'OPTDIColoredAsFill + OPTDIBorderColoredAsStroke',
	#classTraits : 'OPTDIColoredAsFill classTrait + OPTDIBorderColoredAsStroke classTrait',
	#category : #'OpenPonk-Core-DiagramInterchange'
}

{ #category : #update }
OPTDIColoredAsFillAndBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]

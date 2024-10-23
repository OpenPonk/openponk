Trait {
	#name : 'OPTColoredAsFillAndBorderColoredAsStroke',
	#traits : 'OPTColoredAsFill + OPTBorderColoredAsStroke',
	#classTraits : 'OPTColoredAsFill classTrait + OPTBorderColoredAsStroke classTrait',
	#category : 'OpenPonk-Core-DiagramElements',
	#package : 'OpenPonk-Core',
	#tag : 'DiagramElements'
}

{ #category : 'initialization' }
OPTColoredAsFillAndBorderColoredAsStroke >> updateRenderFromStyles [

	self isRendered ifFalse: [ ^ self ].
	self updateColorFromStyles.
	self updateBorderColorFromStyles.
	super updateRenderFromStyles.
	self roassalShape signalUpdate
]

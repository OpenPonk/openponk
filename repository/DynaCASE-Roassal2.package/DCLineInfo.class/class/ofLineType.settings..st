instance creation
ofLineType: aLineClass settings: aBlock
	^ (self ofLineType: aLineClass)
		settingsBlock: aBlock;
		yourself
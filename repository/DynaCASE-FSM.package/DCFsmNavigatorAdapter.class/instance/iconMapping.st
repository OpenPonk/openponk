widget API
iconMapping
	^ {(DCFsm -> DCIcons current dcFsmDiagramIcon).
	(DCFsmInitialState -> DCIcons current dcFsmInitialStateIcon).
	(DCFsmTransition -> DCIcons current dcFsmTransitionIcon).
	(DCFsmState
		-> [ :o | 
			o isNormal
				ifTrue: [ DCIcons current dcFsmRegularStateIcon ]
				ifFalse: [ DCIcons current dcFsmFinalStateIcon ] ])}
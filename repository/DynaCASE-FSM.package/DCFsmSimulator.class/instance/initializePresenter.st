initialization
initializePresenter
	super initializePresenter.
	inputLabel label: 'Input:'.
	input autoAccept: true.
	input textHolder whenChangedDo: [ :text | text ifEmpty: [ start disable ] ifNotEmpty: [ start enable ] ].
	start
		label: 'Start';
		icon: Smalltalk ui icons smallPrintItIcon;
		action: [ self startAction ];
		disable.
	step
		label: 'Step';
		icon: Smalltalk ui icons forwardIcon;
		action: [ self stepAction ];
		disable.
	stop
		label: 'Stop';
		icon: Smalltalk ui icons stopIcon;
		action: [ self stopAction ];
		disable.
	reset
		label: 'Reset';
		icon: Smalltalk ui icons smallUpdateIcon;
		action: [ self resetAction ].
		
	remainderLabel label: 'Remainder: ><'.
	symbolLabel label: 'Symbol: ><'
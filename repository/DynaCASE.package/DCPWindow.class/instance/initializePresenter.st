as yet unclassified
initializePresenter

	button1 whenActionPerformedDo: [ 
			button1 label = 'UML Class' ifTrue: [ 
			view widget class compilerClass new 
			evaluate: 'self add: (DCPDemoClass new width: 100 heigth: 150; name: ''Class'') to: (Point x:100 y: 100).'
			in: nil
			to: view widget
			notifying: nil
			ifFail: [self halt. self flash. ^ nil]
			logged: false. ].
			button1 label = 'Petri state' ifTrue: [view widget class compilerClass new 
			evaluate: 'self add: (DCPPetriState new name: ''State'') to: (Point x:100 y: 100).'
			in: nil
			to: view widget
			notifying: nil
			ifFail: [self halt. self flash. ^ nil]
			logged: false. ]].
	
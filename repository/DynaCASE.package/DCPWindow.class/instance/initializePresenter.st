as yet unclassified
initializePresenter

	button1 whenActionPerformedDo: [ view widget class compilerClass new 
			evaluate: 'self add: (DCPDemoClass new width: 100 heigth: 150; name: ''Neco'') to: (Point x:100 y: 100).'
			in: nil
			to: view widget
			notifying: nil
			ifFail: [self halt. self flash. ^ nil]
			logged: false. ].
	button2 whenActionPerformedDo: [ view widget class compilerClass new 
			evaluate: 'self add: (DCPDemoClass new width: 150 heigth: 120; name: ''Cosi'') to: (Point x:100 y: 100).'
			in: nil
			to: view widget
			notifying: nil
			ifFail: [self halt. self flash. ^ nil]
			logged: false. ].
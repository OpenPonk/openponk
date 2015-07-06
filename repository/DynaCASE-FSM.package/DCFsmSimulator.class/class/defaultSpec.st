specs
defaultSpec
	^ SpecColumnLayout composed
		newRow: [ :row | 
					row
						add: #inputLabel;
						add: #input;
						add: #startButton;
						add: #stopButton;
						add: #resetButton ]
			height: 25;
		newRow: [ :row | row add: #letterPanel ] height: self toolbarHeight;
		newRow: [ :row | 
					row
						add: #backButton;
						add: #nextButton;
						newColumn: [ :col |  ] ]
			height: self toolbarHeight;
		newRow: [ :row |  ];
		yourself
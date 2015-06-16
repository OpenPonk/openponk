specs
defaultSpec
	^ SpecColumnLayout composed
		newRow: [ :row | 
					row
						add: #inputLabel;
						add: #input;
						add: #start;
						add: #step;
						add: #stop;
						add: #reset ]
			height: self toolbarHeight;
		newRow: [ :row | row add: #remainderLabel ] height: self toolbarHeight;
		newRow: [ :row | row add: #symbolLabel ] height: self toolbarHeight;
		newRow: [ :row |  ];
		yourself
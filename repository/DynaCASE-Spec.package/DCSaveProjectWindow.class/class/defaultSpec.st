specs
defaultSpec
	^ SpecColumnLayout composed
		newRow: [ :r | 
			r
				add: #projectNameLabel width: 100;
				add: #projectNameInput ]
			height: 22;
		newRow: [ :r | 
			r
				add: #projectFolderLabel width: 100;
				add: #projectFolderInput;
				add: #projectFolderButton width: 50 ]
			height: 44;
		newRow: [ :r |  ];
		yourself
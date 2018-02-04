specs
defaultSpec
	^ SpecColumnLayout composed
		add: #heading height: self toolbarHeight;
		add: #list;
		yourself
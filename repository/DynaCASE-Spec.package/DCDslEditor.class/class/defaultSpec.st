specs
defaultSpec
	^ SpecColumnLayout new
		newRow: [ :row | row add: #toolbar ] height: self toolbarHeight;
		newRow: [ :row | row add: #editor ];
		newRow: [ :row | row add: #autoUpdate ] height: self toolbarHeight;
		yourself
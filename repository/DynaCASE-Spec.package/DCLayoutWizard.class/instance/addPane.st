adding
addPane
	| pane layoutDropList |
	pane := WizardSinglePane new.
	layoutDropList := DropListPart new
		inGroupboxNamed: 'Layout algorithm';
		horizontalSize: 300;
		list: self layouts;
		format: [ :pair | pair value , ' layout' ];
		defaultValue: self layouts first;
		callback: [ :outputValue | 
			pane removeAllParts.
			pane addPart: layoutDropList associatedTo: #algorithm.
			self addOptionsFor: outputValue key to: pane.
			pane refresh ];
		yourself.
	pane row: layoutDropList associatedTo: #algorithm.
	self addPane: pane
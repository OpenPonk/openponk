settings
settingsOn: aBuilder
	<systemsettings>
	(aBuilder group: #openponk) label: 'OpenPonk'.
	(aBuilder pickOne: #layoutStyle)
		parent: #openponk;
		target: self;
		label: 'Form Layout Style';
		description: 'Separate or combine Palette and Form widgets.';
		default: self defaultLayoutStyle;
		domainValues: self availableLayoutStyles
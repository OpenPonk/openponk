settings
developerSettingsOn: aBuilder
	<systemsettings>
	(aBuilder group: #'op-dev') label: 'OpenPonk Development'; parent: #openponk.
	(aBuilder setting: #isDevelopmentMode)
		parent: #'op-dev';
		target: self;
		label: 'Enable Development Mode';
		description: 'Add extra options useful for developers.';
		default: false
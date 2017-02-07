accessing
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'OpenPonkModel'
					with: [ spec repository: 'github://openponk/openponk-model/repository' ];
				baseline: 'FileDialog'
					with: [ spec repository: 'github://peteruhnak/file-dialog/repository' ];
				project: 'Roassal2'
					with: [ spec
						className: #ConfigurationOfRoassal2;
						versionString: #development;
						repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ];
				project: 'Merlin'
					with: [ spec
						className: #ConfigurationOfMerlin;
						versionString: #development;
						repository: 'http://www.smalltalkhub.com/mc/Moose/Merlin/main' ];
				project: 'PetitParser'
					with: [ spec
						className: #ConfigurationOfPetitParser;
						versionString: #development;
						loads: #('Parser');
						repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ];
				package: 'OpenPonk-Core'
					with: [ spec requires: #('OpenPonkModel' 'Roassal2' 'PetitParser') ];
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2';
				package: 'OpenPonk-Spec' with: [ spec requires: #('Merlin' 'FileDialog') ];
				package: 'OpenPonk-Plugins' with: [ spec postLoadDoIt: #postLoadPlugins ].
			spec
				group: 'default'
				with: #('OpenPonk-Core' 'OpenPonk-Trachel' 'OpenPonk-Roassal2' 'OpenPonk-Spec').
			spec group: 'complete' with: #('default' 'OpenPonk-Plugins') ]
accessing
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'DynaCASEModel'
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
				package: 'DynaCASE-Core'
					with: [ spec requires: #('DynaCASEModel' 'Roassal2' 'PetitParser') ];
				package: 'DynaCASE-Trachel';
				package: 'DynaCASE-Roassal2';
				package: 'DynaCASE-Spec' with: [ spec requires: #('Merlin' 'FileDialog') ];
				package: 'DynaCASE-Plugins' with: [ spec postLoadDoIt: #postLoadPlugins ].
			spec
				group: 'default'
				with: #('DynaCASE-Core' 'DynaCASE-Trachel' 'DynaCASE-Roassal2' 'DynaCASE-Spec').
			spec group: 'complete' with: #('default' 'DynaCASE-Plugins') ]
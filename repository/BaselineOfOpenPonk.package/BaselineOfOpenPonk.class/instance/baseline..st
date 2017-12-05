accessing
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec
				project: 'XMLParser'
				with: [ spec
						className: #ConfigurationOfXMLParser;
						versionString: #stable;
						loads: #(CoreWithWriting);
						repository: 'http://smalltalkhub.com/mc/PharoExtras/XMLParser/main/' ].
			spec
				project: 'XPath'
				with: [ spec
						className: #ConfigurationOfXPath;
						versionString: #stable;
						loads: #(Core);
						repository: 'http://smalltalkhub.com/mc/PharoExtras/XPath/main/' ].
			spec
				baseline: 'OpenPonkModel'
				with: [ spec repository: 'github://openponk/openponk-model/repository' ].
			spec
				baseline: 'FileDialog'
				with: [ spec repository: 'github://peteruhnak/file-dialog/repository' ].
			spec
				project: 'Roassal2'
				with: [ spec
						className: #ConfigurationOfRoassal2;
						versionString: #development;
						loads: #(Roassal2 Roassal2Spec Roassal2GT);
						repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ].
			spec
				project: 'Magritte'
				with: [ spec
						className: #ConfigurationOfMagritte3;
						versionString: #stable;
						repository: 'http://smalltalkhub.com/mc/Magritte/Magritte3/main/' ].
			spec
				project: 'Merlin'
				with: [ spec
						className: #ConfigurationOfMerlin;
						versionString: #development;
						repository: 'http://www.smalltalkhub.com/mc/Moose/Merlin/main' ].
			spec
				baseline: 'Mocketry'
				with: [ spec repository: 'github://dionisiydk/Mocketry:v4.0.x' ].
			spec
				project: 'PetitParser'
				with: [ spec
						className: #ConfigurationOfPetitParser;
						versionString: #development;
						loads: #('Parser');
						repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ].
			spec
				package: 'OpenPonk-Core'
					with: [ spec
						requires: #('OpenPonkModel' 'Magritte' 'Mocketry' 'Roassal2' 'PetitParser' 'XMLParser' 'XPath') ];
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2';
				package: 'OpenPonk-Telemetry';
				package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec requires: #('Merlin' 'FileDialog' 'Magritte') ];
				package: 'OpenPonk-Plugins' with: [ spec postLoadDoIt: #postLoadPlugins ].
			spec
				group: 'default'
				with:
					#('OpenPonk-Core' 'OpenPonk-Trachel' 'OpenPonk-Roassal2' 'OpenPonk-Spec' 'OpenPonk-Telemetry' 'OpenPonk-Help').
			spec group: 'complete' with: #('default' 'OpenPonk-Plugins') ]
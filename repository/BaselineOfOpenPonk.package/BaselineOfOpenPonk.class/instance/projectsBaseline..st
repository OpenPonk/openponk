accessing
projectsBaseline: spec
	spec baseline: 'Commander' with: [ spec repository: 'github://dionisiydk/Commander' ].
	spec
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
				versionString: #stable;
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
		baseline: 'Sentry'
		with: [ spec repository: 'github://peteruhnak/pharo-sentry/repository' ].
	spec
		baseline: 'SynchronizedLinks'
		with: [ spec repository: 'github://openponk/synchronized-links/repository' ]
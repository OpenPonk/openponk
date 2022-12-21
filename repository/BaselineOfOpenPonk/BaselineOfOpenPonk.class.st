"
I am baseline for the core and all-in-one dynacase.
https://dynacase.github.io/
"
Class {
	#name : #BaselineOfOpenPonk,
	#superclass : #BaselineOf,
	#category : #BaselineOfOpenPonk
}

{ #category : #baselines }
BaselineOfOpenPonk >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self externalProjectsBaseline: spec.
		self internalProjectsBaseline: spec.
		spec
			package: 'OpenPonk-Trachel'
			with: [ spec requires: #( 'Roassal2' ) ];
			package: 'OpenPonk-Roassal2'
			with: [ spec requires: #( 'OpenPonk-Trachel' ) ];
			package: 'OpenPonk-Roassal3'
			with: [ spec preLoadDoIt: #loadRoassal3 ];
			package: 'OpenPonk-Core' with: [ 
				spec requires:
						#( 'Magritte' 'Mocketry' 'XMLParser' 'XPath' 'NeoJSON' 'OpenPonk-Roassal2'
						   'OpenPonk-Roassal3' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Spec' with: [ 
				spec requires:
						#( 'Moose' 'NewTools' 'Magritte' 'SynchronizedLinks'
						   'OpenPonk-Morphic' );  preLoadDoIt: #loadPetitParserAndRoassal3 ].
		spec
			group: 'default'
			with: #( 'OpenPonk-Core' 'OpenPonk-Morphic' 'OpenPonk-Spec' ) ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [

	spec baseline: 'XMLParser' with: [ 
		spec
			repository: 'github://pharo-contributions/XML-XMLParser:3.5.x/src';
			loads: #( Core ) ].

	spec baseline: 'XPath' with: [ 
		spec
			repository: 'github://pharo-contributions/XML-XPath:3450f91/src';
			loads: #( Core ) ].

	spec baseline: 'Roassal2' with: [ 
		spec
			repository: 'github://OpenPonk/Roassal2:Pharo10';
			loads: #( Core ) ].

	spec baseline: 'Magritte' with: [ 
		spec
			repository:
				'github://JanBliznicenko/magritte:fix-spec-usage/source';
			loads: #( Core 'Magritte-Morph' ) ].

	spec baseline: 'Moose' with: [ 
		spec
			repository: 'github://moosetechnology/Moose:v9.0.1/src';
			loads: #( Merlin ) ].

	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v7.0.1' ].

	spec
		baseline: 'NeoJSON'
		with: [ 
		spec repository: 'github://svenvc/NeoJSON:109d08b/repository' ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [

	spec baseline: 'NewTools' with: [ 
		spec
			repository: 'github://JanBliznicenko/NewTools:Pharo10';
			loads: #( FileBrowser ) ].
	spec
		baseline: 'SynchronizedLinks'
		with: [ 
		spec repository: 'github://openponk/synchronized-links/repository' ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> loadPetitParser [

	"PetitParser is not needed by core OP. It is needed by BormEditor, but due to Pharo bug https://github.com/pharo-project/pharo/issues/9913 it must be always loaded before Roassal2 in Pharo 10"

	Smalltalk at: #BaselineOfPetitParser ifPresent: [ ^ self ].
	Metacello new
		baseline: 'PetitParser';
		repository: 'github://moosetechnology/PetitParser:v3.x.x/src';
		load:
			#( 'Core' 'Tests' 'Examples' 'Islands' 'Analyzer' 'Preprocessor'
			   'Indent' 'Extension' 'TestsExtension' 'Parser' )
]

{ #category : #baselines }
BaselineOfOpenPonk >> loadPetitParserAndRoassal3 [

	"PetitParser is not needed by core OP. It is needed by BormEditor, but due to Pharo bug https://github.com/pharo-project/pharo/issues/9913 it must be always loaded before Roassal in Pharo 10"

	self
		loadPetitParser;
		loadRoassal3
]

{ #category : #baselines }
BaselineOfOpenPonk >> loadRoassal3 [

	"Roassal3 needs to be loaded this way because different version of it is already included in Pharo 10+"

	Smalltalk at: #BaselineOfRoassal3Exporters ifPresent: [ ^ self ].
	[ 
	Metacello new
		baseline: 'Roassal3';
		"repository: 'github://ObjectProfile/Roassal3:v0.9.9k';"
		repository: 'github://OpenPonk/Roassal3';
		lock;
		load: #Full ]
		on: MCMergeOrLoadWarning
		do: [ :warning | warning load ].
	Metacello new
		baseline: 'Roassal3Exporters';
		repository: 'github://ObjectProfile/Roassal3Exporters:f2f81e9';
		load
]

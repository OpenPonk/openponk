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
			package: 'OpenPonk-Core' with: [ 
				spec requires:
						#( 'Magritte' 'Mocketry' 'Roassal2' 'XMLParser' 'XPath' 'NeoJSON' ) ];
			package: 'OpenPonk-Trachel'
			with: [ spec requires: #( 'Roassal2' ) ];
			package: 'OpenPonk-Roassal2'
			with: [ spec requires: #( 'OpenPonk-Trachel' 'Roassal2' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Help';
			package: 'OpenPonk-Spec' with: [ 
				spec requires:
						#( 'Moose' 'FileDialog' 'Magritte' 'SynchronizedLinks'
						   'OpenPonk-Morphic' ) ].
		spec
			group: 'default'
			with: #( 'OpenPonk-Core' 'OpenPonk-Roassal2' 'OpenPonk-Morphic'
				   'OpenPonk-Spec' 'OpenPonk-Help' ) ]
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
	spec
		baseline: 'Roassal2'
		with: [ 
		spec repository: 'github://ObjectProfile/Roassal2:v2.0.2/src' ].
	spec baseline: 'Magritte' with: [ 
		spec
			repository: 'github://magritte-metamodel/magritte:dc9a440/source';
			loads: #( Core 'Magritte-Morph' ) ].
	spec baseline: 'Moose' with: [ 
		spec
			repository: 'github://moosetechnology/Moose:b5163b2/src';
			loads: #( Merlin ) ].
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v6.0.3' ].
	spec
		baseline: 'NeoJSON'
		with: [ 
		spec repository: 'github://svenvc/NeoJSON:a16e02b/repository' ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [

	spec
		baseline: 'FileDialog'
		with: [ 
		spec repository: 'github://peteruhnak/file-dialog:v1.x/repository' ].
	spec
		baseline: 'SynchronizedLinks'
		with: [ 
		spec repository: 'github://openponk/synchronized-links:v2.1.x/repository' ]
]

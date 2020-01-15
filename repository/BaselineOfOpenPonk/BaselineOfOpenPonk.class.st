"
I am baseline for the core and all-in-one dynacase.
https://dynacase.github.io/
"
Class {
	#name : #BaselineOfOpenPonk,
	#superclass : #BaselineOf,
	#category : 'BaselineOfOpenPonk'
}

{ #category : #accessing }
BaselineOfOpenPonk >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ self externalProjectsBaseline: spec.
			self internalProjectsBaseline: spec.
			spec
				package: 'OpenPonk-Core'
					with: [ spec
						requires: #('Magritte' 'Mocketry' 'Roassal2' 'PetitParser' 'XMLParser' 'XPath' 'NeoJSON') ];
				package: 'OpenPonk-Perf';
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2';
				package: 'OpenPonk-Morphic';
				package: 'OpenPonk-Telemetry'
					with: [ spec requires: #('Sentry') ];
				package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec requires: #('Merlin' 'FileDialog' 'Magritte' 'Commander' 'SynchronizedLinks' 'OpenPonk-Morphic') ];
				package: 'OpenPonk-UI';
				package: 'OpenPonk-Plugins'
					with: [ spec postLoadDoIt: #postLoadPlugins ].
			spec
				group: 'default'
				with: #('OpenPonk-Core' 'OpenPonk-Perf' 'OpenPonk-Trachel' 'OpenPonk-Roassal2' 'OpenPonk-Morphic' 'OpenPonk-Spec' 'OpenPonk-UI' 'OpenPonk-Telemetry' 'OpenPonk-Help').
			spec group: 'complete' with: #('default' 'OpenPonk-Plugins') ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [
	spec
		baseline: 'Commander'
		with: [ spec repository: 'github://pharo-ide/Commander:v0.7.0/src' ].
	spec
		baseline: 'XMLParser'
		with: [ spec repository: 'github://pharo-contributions/XML-XMLParser/src' ].
	spec
		baseline: 'XPath'
		with: [ spec repository: 'github://pharo-contributions/XML-XPath/src' ].
	spec
		baseline: 'Roassal2'
		with: [ spec repository: 'github://ObjectProfile/Roassal2/src' ].
	spec 
		baseline: 'Magritte' 
		with: [ spec repository: 'github://magritte-metamodel/magritte'; 
             loads: #(Core) ].
	spec 
		baseline: 'Merlin' 
		with: [ spec repository: 'github://moosetechnology/Moose/src'; 
             loads: #(Merlin) ].
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry' ].
	spec
		baseline: 'PetitParser'
		with: [ spec repository: 'github://moosetechnology/PetitParser/src' ].
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [
	spec
		baseline: 'FileDialog'
		with: [ spec repository: 'github://peteruhnak/file-dialog:v1.x/repository' ].
	spec
		baseline: 'Sentry'
		with: [ spec repository: 'github://peteruhnak/pharo-sentry:v1.x/repository' ].
	spec
		baseline: 'SynchronizedLinks'
		with: [ spec repository: 'github://openponk/synchronized-links:v1.x/repository' ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> postLoadPlugins [
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://openponk/borm-editor/repository';
		onConflict: [ :ex | ex allow ];
		load.
	Metacello new
		baseline: 'ClassEditor';
		repository: 'github://openponk/class-editor/repository';
		onConflict: [ :ex | ex allow ];
		load
]

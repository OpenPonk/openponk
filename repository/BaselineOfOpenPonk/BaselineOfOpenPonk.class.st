"
I am baseline for the core and all-in-one dynacase.
https://dynacase.github.io/
"
Class {
	#name : #BaselineOfOpenPonk,
	#superclass : #BaselineOf,
	#category : #BaselineOfOpenPonk
}

{ #category : #plugins }
BaselineOfOpenPonk class >> loadBormEditor [
	self new loadBormEditor
]

{ #category : #plugins }
BaselineOfOpenPonk class >> loadClassEditor [
	self new loadClassEditor
]

{ #category : #plugins }
BaselineOfOpenPonk class >> loadDemoEditor [
	self new loadDemoEditor
]

{ #category : #plugins }
BaselineOfOpenPonk class >> loadFsmEditor [
	self new loadFsmEditor
]

{ #category : #plugins }
BaselineOfOpenPonk class >> loadPetriNets [
	self new loadPetriNets
]

{ #category : #plugins }
BaselineOfOpenPonk class >> loadPlugins [
	self new loadPlugins
]

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
						requires: #('Magritte' 'Mocketry' 'Roassal2' 'XMLParser' 'XPath' 'NeoJSON') ];
				package: 'OpenPonk-Perf';
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2';
				package: 'OpenPonk-Morphic';
				"package: 'OpenPonk-Telemetry'
					with: [ spec requires: #('Sentry') ];"
					package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec
						requires:
							#('Moose' 'FileDialog' 'Magritte' 'SynchronizedLinks' 'OpenPonk-Morphic')	" 'Commander'" ];
				package: 'OpenPonk-Plugins'
					with: [ spec postLoadDoIt: #loadPlugins ].
			spec
				group: 'default'
				with:
					#('OpenPonk-Core' 'OpenPonk-Perf' 'OpenPonk-Trachel' 'OpenPonk-Roassal2' 'OpenPonk-Morphic' 'OpenPonk-Spec' 'OpenPonk-Help').	"'OpenPonk-Telemetry'"
			spec group: 'complete' with: #('default' 'OpenPonk-Plugins') ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [
	spec
		baseline: 'XMLParser'
		with: [ spec
				repository: 'github://pharo-contributions/XML-XMLParser:3.5.x/src' ].
	spec
		baseline: 'XPath'
		with:
			[ spec repository: 'github://pharo-contributions/XML-XPath:2.2.0/src' ].
	spec
		baseline: 'Roassal2'
		with: [ spec
				repository:
					'github://ObjectProfile/Roassal2:614d7b80eebf6af33a777cec55ecc1c6a7a65482/src';
				postLoadDoIt: #loadPetitParser ].
	spec
		baseline: 'Magritte'
		with: [ spec
				repository:
					'github://magritte-metamodel/magritte:49781e985875315d06c5991f094c30d6f8c9f02d/source';
				loads: #(Core 'Magritte-Morph');
				postLoadDoIt: #removeGreaseWarnings ].
	spec
		baseline: 'Moose'
		with: [ spec
				repository: 'github://moosetechnology/Moose:3693b26/src';
				loads: #(Merlin) ].
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://JanBliznicenko/Mocketry:pharo9' ].
	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [
	spec
		baseline: 'FileDialog'
		with: [ spec repository: 'github://peteruhnak/file-dialog:v1.x/repository' ].
	"spec
		baseline: 'Sentry'
		with: [ spec repository: 'github://peteruhnak/pharo-sentry:v1.x/repository' ]."
	spec
		baseline: 'SynchronizedLinks'
		with: [ spec repository: 'github://openponk/synchronized-links:v2.0.0/repository' ]
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadBormEditor [
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://openponk/borm-editor:v2.0.1/repository';
		load: #(plugin)
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadClassEditor [
	Metacello new
		baseline: 'ClassEditor';
		repository: 'github://openponk/class-editor:v2.1.x/repository';
		load: #('complete-plugin')
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadDemoEditor [
	self notify: 'OpenPonk DEMO project is abandoned - it is not working'.
	Metacello new
		baseline: 'DemoEditor';
		repository: 'github://openponk/demo-editor:v2.0.1/repository';
		load: #(plugin)
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadFsmEditor [
	Metacello new
		baseline: 'FsmEditor';
		repository: 'github://openponk/fsm-editor:v2.0.1/repository';
		load: #(plugin)
]

{ #category : #accessing }
BaselineOfOpenPonk >> loadPetitParser [
	"this is solved separatedly by direct loading code because PetitParser does not specify Roassal2 version, which causes conflicts and this is probably only way to use onConflict:"
	
	Metacello new
		baseline: 'PetitParser';
		repository: 'github://moosetechnology/PetitParser:v2.x.x/src';
		onConflict: [ :err | err useLoaded ];
		load
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadPetriNets [
	Metacello new
		baseline: 'PetriNets';
		repository: 'github://openponk/petrinets:v2.0.1/repository';
		load: #(plugin)
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadPlugins [
	self
		loadBormEditor;
		loadClassEditor;
		"loadDemoEditor;" "OpenPonk DEMO project is abandoned - it is not working"
		loadFsmEditor;
		loadPetriNets
]

{ #category : #scripts }
BaselineOfOpenPonk >> removeGreaseWarnings [
	('Grease-Pharo40-Slime' asPackageIfAbsent: [ ^ self ])
		removeFromSystem.
	'Grease-Core' asPackage mcWorkingCopy modified: false
]

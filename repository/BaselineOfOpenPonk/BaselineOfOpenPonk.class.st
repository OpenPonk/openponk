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
			self pluginsBaseline: spec.
			spec
				package: 'OpenPonk-Core'
					with: [ spec
						requires: #('Magritte' 'Mocketry' 'Roassal2' 'XMLParser' 'XPath' 'NeoJSON') ];
				package: 'OpenPonk-Perf';
				package: 'OpenPonk-Trachel';
				package: 'OpenPonk-Roassal2'
					with: [ spec requires: 'OpenPonk-Trachel' ];
				package: 'OpenPonk-Morphic';
				"package: 'OpenPonk-Telemetry'
					with: [ spec requires: #('Sentry') ];"
				package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec
						requires:
							#('Moose' 'FileDialog' 'Magritte' 'Commander' 'SynchronizedLinks' 'OpenPonk-Morphic') ];
				package: 'OpenPonk-UI'.
			spec
				group: 'default'
				with:
					#('OpenPonk-Core' 'OpenPonk-Perf' 'OpenPonk-Roassal2' 'OpenPonk-Morphic' 'OpenPonk-Spec' 'OpenPonk-UI' 'OpenPonk-Help' "'OpenPonk-Telemetry'").	
			spec group: 'complete' with: #('default' 'plugins') ]
]

{ #category : #accessing }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [
	spec
		baseline: 'Commander'
		with: [ spec repository: 'github://pharo-ide/Commander:v0.7.0/src' ].
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
					'github://ObjectProfile/Roassal2:004ab6f3dfd41cf06526c57115ee42cc921e7668/src';
				postLoadDoIt: #loadPetitParser ].
	spec
		baseline: 'Magritte'
		with: [ spec
				repository: 'github://magritte-metamodel/magritte:v3.6/source';
				loads: #(Core 'Magritte-Morph') ].
	spec
		baseline: 'Moose'
		with: [ spec
				repository: 'github://moosetechnology/Moose:24a33d7/src';
				loads: #(Merlin) ].
	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v6.0.0' ].
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
		with: [ spec repository: 'github://openponk/synchronized-links:v1.x/repository' ]
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadBormEditor [
	Metacello new
		baseline: 'BormEditor';
		repository: 'github://openponk/borm-editor/repository';
		load
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadClassEditor [
	Metacello new
		baseline: 'ClassEditor';
		repository: 'github://openponk/class-editor/repository';
		load
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadDemoEditor [
	self
		notify:
			'OpenPonk DEMO project is no longer updated. It does not work with current version of OpenPonk'.
	Metacello new
		baseline: 'DemoEditor';
		repository: 'github://openponk/demo-editor/repository';
		load
]

{ #category : #plugins }
BaselineOfOpenPonk >> loadFsmEditor [
	Metacello new
		baseline: 'FsmEditor';
		repository: 'github://openponk/fsm-editor/repository';
		load
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
		repository: 'github://openponk/petrinets/repository';
		load
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

{ #category : #accessing }
BaselineOfOpenPonk >> pluginsBaseline: spec [
	spec
		package: 'BormEditor'
		with: [ spec
				requires: 'default';
				postLoadDoIt: #loadBormEditor ].
	spec
		package: 'ClassEditor'
		with: [ spec
				requires: 'default';
				postLoadDoIt: #loadClassEditor ].
	spec
		package: 'FsmEditor'
		with: [ spec
				requires: 'default';
				postLoadDoIt: #loadFsmEditor ].
	spec
		package: 'PetriNets'
		with: [ spec
				requires: 'default';
				postLoadDoIt: #loadPetriNets ].
	spec
		package: 'plugins'
		with: [ spec requires: #(BormEditor ClassEditor FsmEditor PetriNets) ]
]

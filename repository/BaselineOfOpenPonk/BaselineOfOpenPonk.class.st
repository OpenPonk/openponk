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
			package: 'OpenPonk-Roassal3'
			with: [ spec preLoadDoIt: #loadRoassal3 ];
			package: 'OpenPonk-Core' with: [
				spec requires:
						#( 'Magritte' 'Mocketry' 'XMLParser' 'XPath' 'NeoJSON' 'OpenPonk-Roassal3' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Spec' with: [
				spec
					requires:
						#( 'NewTools' 'Magritte' 'SynchronizedLinks' 'OpenPonk-Morphic' );
					preLoadDoIt: #loadPetitParserAndRoassal3 ].
		spec
			group: 'default'
			with: #( 'OpenPonk-Core' 'OpenPonk-Morphic' 'OpenPonk-Spec' ) ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [

	spec baseline: 'XMLParser' with: [
		spec
			repository: 'github://pharo-contributions/XML-XMLParser:4f9cb10';
			loads: #( Core ) ].

	spec baseline: 'XPath' with: [
		spec
			repository: 'github://pharo-contributions/XML-XPath:c063098';
			loads: #( Core ) ].

	spec baseline: 'Magritte' with: [
		spec
			repository: 'github://magritte-metamodel/magritte:b24afda';
			loads: #( Core 'Magritte-Morph' ) ].

	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v7.0.2' ].

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON:b05162a' ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [

	spec baseline: 'NewTools' with: [ 
		spec
			repository: 'github://pharo-spec/NewTools:Pharo11';
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

	| exporters |
	Smalltalk at: #BaselineOfRoassal3Exporters ifPresent: [ ^ self ].

	exporters := Metacello new.
	exporters
		baseline: 'Roassal3Exporters';
		repository: 'github://OpenPonk/Roassal3Exporters:master';
		lock;
		onConflictUseLoaded.
	[
	Metacello new
		baseline: 'Roassal3';
		repository: 'github://OpenPonk/Roassal3:master';
		lock;
		load: #Full ]
		on: MCMergeOrLoadWarning
		do: [ :warning | warning load ].
	exporters load
]

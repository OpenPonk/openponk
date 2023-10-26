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
			package: 'OpenPonk-Roassal'
			with: [
				spec requires: #( 'Roassal' 'RoassalExporters' ) ];
			package: 'OpenPonk-Core' with: [
				spec requires:
						#( 'Magritte' 'Mocketry' 'XMLParser' 'XPath' 'NeoJSON' 'OpenPonk-Roassal' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Spec' with: [
				spec
					requires:
						#( 'NewTools' 'Magritte' 'SynchronizedLinks' 'OpenPonk-Morphic' );
					preLoadDoIt: #loadPetitParser ].
		spec
			group: 'default'
			with: #( 'OpenPonk-Core' 'OpenPonk-Morphic' 'OpenPonk-Spec' ) ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [

	spec baseline: 'XMLParser' with: [
		spec
			repository: 'github://pharo-contributions/XML-XMLParser:3.5.x';
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
		with: [ spec repository: 'github://svenvc/NeoJSON:b05162a' ].

	spec baseline: 'Roassal' with: [
		spec
			repository: 'github://pharo-graphics/Roassal:b508334';
			loads: #Full;
			preLoadDoIt: #removeOldRoassal3 ].

	spec
		baseline: 'RoassalExporters'
		with: [
		spec repository: 'github://pharo-graphics/RoassalExporters:v1.01' ]
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
BaselineOfOpenPonk >> loadPetitParserAndRoassal [

	"PetitParser is not needed by core OP. It is needed by BormEditor, but due to Pharo bug https://github.com/pharo-project/pharo/issues/9913 it must be always loaded before Roassal in Pharo 10"

	self
		loadPetitParser;
		loadRoassal
]

{ #category : #baselines }
BaselineOfOpenPonk >> loadRoassal [
	"Roassal3 needs to be loaded this way because different version of it is already included in Pharo 10+"

	| exporters layouts |
	
	Smalltalk at: #BaselineOfRoassalExporters ifPresent: [ ^ self ].

	layouts := Metacello new.
	layouts
		baseline: 'RoassalLayouts';
		repository: 'github://pharo-graphics/RoassalLayouts:136a902';
		lock;
		onConflictUseLoaded.

	exporters := Metacello new.
	exporters
		baseline: 'RoassalExporters';
		repository: 'github://pharo-graphics/RoassalExporters:v1.01';
		lock;
		onConflictUseLoaded.
		
	[
	Metacello new
		baseline: 'Roassal';
		repository: 'github://pharo-graphics/Roassal:b508334';
		lock;
		load: #Full ]
		on: MCMergeOrLoadWarning
		do: [ :warning | warning load ].
		
	layouts load.
	exporters load
]

{ #category : #baselines }
BaselineOfOpenPonk >> removePackage: aPackageName [

	| regExp packages |
	regExp := '*' , aPackageName , '*'.
	packages := RPackageOrganizer default packages select: [ :each |
		            regExp match: each name ].
	packages do: [ :each | each removeFromSystem ]
]

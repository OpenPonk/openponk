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
	spec
		for: #common
		do: [ self externalProjectsBaseline: spec.
			self internalProjectsBaseline: spec.
			spec
				package: 'OpenPonk-Trachel'
					with: [ spec requires: #('Roassal2') ];
				package: 'OpenPonk-Roassal2'
					with: [ spec requires: #('OpenPonk-Trachel') ];
				package: 'OpenPonk-Core'
					with: [ spec
						requires:
							#('Magritte' 'Mocketry' 'XMLParser' 'XPath' 'NeoJSON' 'OpenPonk-Roassal2') ];
				package: 'OpenPonk-Morphic';
				package: 'OpenPonk-Help';
				package: 'OpenPonk-Spec'
					with: [ spec
						requires:
							#('Moose' 'FileDialog' 'Magritte' 'SynchronizedLinks' 'OpenPonk-Morphic') ];
				preLoadDoIt: #loadPetitParser.
			spec
				group: 'baseForAllPharoVersions'
				with:
					#('OpenPonk-Core' 'OpenPonk-Roassal2' 'OpenPonk-Morphic' 'OpenPonk-Spec' 'OpenPonk-Help').
			spec package: 'OpenPonk-Pharo8SysExtensions'.
			spec
				package: 'OpenPonk-Pharo8OPExtensions'
				with: [ spec
						requires: #('OpenPonk-Pharo8SysExtensions' 'baseForAllPharoVersions') ].
			spec
				for: #(#'pharo8.x' #'pharo7.x')
					do: [ spec group: 'default' with: #('OpenPonk-Pharo8OPExtensions') ];
				for: #(#'pharo11.x' #'pharo10.x' #'pharo9.x')
					do: [ spec group: 'default' with: #(#baseForAllPharoVersions) ] ]
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
			repository: 'github://ObjectProfile/Roassal2:v2.0.2/src';
			loads: #( Core ) ].
	spec baseline: 'Magritte' with: [ 
		spec
			repository: 'github://magritte-metamodel/magritte:1b902c9/source';
			loads: #( Core 'Magritte-Morph' ) ].
	spec baseline: 'Moose' with: [ 
		spec
			repository: 'github://moosetechnology/Moose:f2b6052/src';
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

	spec baseline: 'FileDialog' with: [ 
		spec repository:
			'github://peteruhnak/file-dialog:3faba6b/repository' ].
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
		repository: 'github://moosetechnology/PetitParser:v2.x.x/src';
		load:
			#( 'Core' 'Tests' 'Examples' 'Islands' 'Analyzer' 'Preprocessor'
			   'Indent' 'Extension' 'TestsExtension' 'Parser' )
]

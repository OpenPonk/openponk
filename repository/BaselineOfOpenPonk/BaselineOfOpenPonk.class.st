"
I am baseline for the core of Openponk.
https://openponk.org/
"
Class {
	#name : 'BaselineOfOpenPonk',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfOpenPonk',
	#package : 'BaselineOfOpenPonk'
}

{ #category : 'baselines' }
BaselineOfOpenPonk >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self externalProjectsBaseline: spec.
		self internalProjectsBaseline: spec.
		spec
			package: 'OpenPonk-Roassal'
			with: [ spec requires: #( 'Roassal' 'RoassalExporters' ) ];
			package: 'OpenPonk-Core' with: [
				spec requires:
						#( 'Magritte' 'Mocketry' 'XPath' 'NeoJSON' 'OpenPonk-Roassal' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Spec' with: [
				spec requires:
						#( 'NewTools' 'Magritte' 'OpenPonkSynchronizedLinks' 'OpenPonk-Morphic' ) ];
			package: 'OpenPonk-Releaser'.
		spec
			group: 'default'
			with: #( 'OpenPonk-Core' 'OpenPonk-Morphic' 'OpenPonk-Spec' );
			group: 'dev' with: #( 'default' 'OpenPonk-Releaser' ) ]
]

{ #category : 'baselines' }
BaselineOfOpenPonk >> externalProjectsBaseline: spec [

	spec
		baseline: 'XPath'
		with: [
		spec repository: 'github://pharo-contributions/XML-XPath:v2.3.x' ].

	spec baseline: 'Magritte' with: [
		spec
			repository: 'github://JanBliznicenko/magritte:6d92c9d';
			loads: #( Core 'Magritte-Morph' ) ].

	spec
		baseline: 'Mocketry'
		with: [ spec repository: 'github://dionisiydk/Mocketry:v7.0.2' ].

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON:17efabc' ].

	spec baseline: 'Roassal' with: [
		spec
			repository: 'github://pharo-graphics/Roassal:v1.06f';
			loads: #Full;
			postLoadDoIt: #removeRoassalExplicitRequirements ].

	spec
		baseline: 'RoassalExporters'
		with: [
		spec repository: 'github://pharo-graphics/RoassalExporters:v1.02' ].

	spec baseline: 'NewTools' with: [
		spec
			repository: 'github://pharo-spec/NewTools:Pharo12';
			loads: #( FileBrowser ) ]
]

{ #category : 'baselines' }
BaselineOfOpenPonk >> internalProjectsBaseline: spec [

	spec
		baseline: 'OpenPonkSynchronizedLinks'
		with: [ spec repository: 'github://openponk/synchronized-links:v4.1.x' ]
]

{ #category : 'baselines' }
BaselineOfOpenPonk >> removeExplicitRequirementsFromPackage: aPackageName [

	| regExp packages |
	regExp := '*' , aPackageName , '*'.
	packages := PackageOrganizer default packages select: [ :each |
		            regExp match: each name ].
	packages do: [ :each |
		Transcript crShow:
			'Removing explicitRequirements from package ' , each name.
		each classes select: #isTrait thenDo: [ :eachClass |
			eachClass methods
				select: [ :eachMethod |
					eachMethod sourceCode includesSubstring:
						'self explicitRequirement' ]
				thenDo: #removeFromSystem ] ]
]

{ #category : 'baselines' }
BaselineOfOpenPonk >> removePackage: aPackageName [

	| regExp packages |
	regExp := '*' , aPackageName , '*'.
	packages := PackageOrganizer default packages select: [ :each |
		            regExp match: each name ].
	packages do: [ :each |
		Transcript crShow: 'Removing package ' , each name.
		each removeFromSystem ]
]

{ #category : 'baselines' }
BaselineOfOpenPonk >> removeRoassalExplicitRequirements [

	#( Roassal Numeric RTree OpenPonk OP OntoUML ) do: [ :eachName |
		self removeExplicitRequirementsFromPackage: eachName ]
]

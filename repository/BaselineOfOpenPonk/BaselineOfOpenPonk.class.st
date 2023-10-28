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
			with: [ spec requires: #( 'Roassal' 'RoassalExporters' ) ];
			package: 'OpenPonk-Core' with: [
				spec requires:
						#( 'Magritte' 'Mocketry' 'XMLParser' 'XPath' 'NeoJSON' 'OpenPonk-Roassal' ) ];
			package: 'OpenPonk-Morphic';
			package: 'OpenPonk-Spec' with: [
				spec requires:
						#( 'NewTools' 'Magritte' 'SynchronizedLinks' 'OpenPonk-Morphic' ) ].
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
			repository: 'github://pharo-graphics/Roassal:3a0cdc0';
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
BaselineOfOpenPonk >> removeOldRoassal3 [

	(RPackageOrganizer default includesPackageNamed: 'Roassal3')
		ifFalse: [ ^ self ].
	#( Roassal3 Numeric ) do: [ :eachName | self removePackage: eachName ]
]

{ #category : #baselines }
BaselineOfOpenPonk >> removePackage: aPackageName [

	| regExp packages |
	regExp := '*' , aPackageName , '*'.
	packages := RPackageOrganizer default packages select: [ :each |
		            regExp match: each name ].
	packages do: [ :each |
		Transcript crShow: 'Removing package ' , each name.
		each removeFromSystem ]
]

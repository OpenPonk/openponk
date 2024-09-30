Class {
	#name : 'OPRSDependenciesMapBuilder',
	#superclass : 'RSThemedMapBuilder',
	#classInstVars : [
		'openPonkBaselines'
	],
	#category : 'OpenPonk-Roassal-Meta',
	#package : 'OpenPonk-Roassal',
	#tag : 'Meta'
}

{ #category : 'instance creation' }
OPRSDependenciesMapBuilder class >> open [

	<script>
	| canvas |
	canvas := self new
		          baseline: BaselineOfOpenPonkPlugins;
		          build;
		          canvas.

	^ canvas
		  open;
		  yourself
]

{ #category : 'accessing' }
OPRSDependenciesMapBuilder class >> openPonkBaselines [

	^ openPonkBaselines ifNil: [
		  openPonkBaselines := #( OpenPonk OpenPonkPlugins PetriNets
		                          FsmEditor ClassEditor BormEditor
		                          BPMN MarkovChains OpenPonkSimulation
		                          BormModel UMLProfiles UMLBootstrapGenerator
		                          OPUMLXMI UMLMetamodel OPXMI XMLDOMVisitor
		                          SynchronizedLinks OpenPonkModel
		                          OpenPonkModelSimulation
		                          OntoUMLVerificationFramework
		                          OntoUMLModelQuery OntoUMLProfile
		                          OntoUMLPatterns OntoUMLTransformationFramework
		                          OpenPonkGit ) asSet ]
]

{ #category : 'accessing' }
OPRSDependenciesMapBuilder class >> resetOpenPonkBaselines [

	<script>
	openPonkBaselines := nil
]

{ #category : 'hooks - model' }
OPRSDependenciesMapBuilder >> computeModels [

	| verResults |
	verResults := Smalltalk globals
		              at: #BaselineOfOntoUMLVerificationFramework
		              ifAbsent: [ ^ super computeModels ].
	[
	Smalltalk globals removeKey: #BaselineOfOntoUMLVerificationFramework.
	super computeModels ] ensure: [
		Smalltalk globals at: #BaselineOfOntoUMLVerificationFramework put: verResults ]
]

{ #category : 'hooks - model' }
OPRSDependenciesMapBuilder >> dependenciesFrom: aBMBaselineModel [

	^ aBMBaselineModel baselineClass version projects
		  collect: #constructClassName
		  thenSelect: [ :each |
			  each isNotNil and: [
				  (each includesAnyOf: {
						   $-.
						   Character space }) not ] ]
]

{ #category : 'hooks' }
OPRSDependenciesMapBuilder >> layoutOn: aCanvas [

	OPRSBaselineDominanceTreeLayout new
		horizontalGap: 50;
		verticalGap: 5;
		on: aCanvas nodes
]

{ #category : 'instance creation' }
OPRSDependenciesMapBuilder >> newBorderFor: model [

	| border shortName |
	border := RSBorder new
		color: self theme textColor;
		width: 1;
		yourself.
		
	shortName := model name allButFirst: 10.
	
	(self class openPonkBaselines includes: shortName)
		ifFalse: [ border color: Color gray ].
		
	^ border
]

{ #category : 'instance creation' }
OPRSDependenciesMapBuilder >> newBox [
	^ super newBox
		color: Color white;
		yourself
]

{ #category : 'instance creation' }
OPRSDependenciesMapBuilder >> newLabelFor: model [

	| label shortName |
	shortName := model name allButFirst: 10.

	label := RSLabel new
		         text: shortName;
		         color: Color black;
		         yourself.

	(self class openPonkBaselines includes: shortName) ifFalse: [
		label color: Color gray ].

	^ label
]

{ #category : 'hooks' }
OPRSDependenciesMapBuilder >> renderLinesOn: aCanvas [

	self newLineBuilder
		canvas: aCanvas;
		connectToAll: [ :model |
			model dependencies collect: [ :depName |
					models detect: [ :each | each name = depName ] ] ].
	aCanvas lines do: [ :each |
		| shortName |
		shortName := each to model name allButFirst: 10.
		(self class openPonkBaselines includes: shortName) ifFalse: [
			each
				color: Color gray;
				signalUpdate ] ].
	aCanvas lines pushBack
]

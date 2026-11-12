"
Verifies building the baseline dependency visualization and dominance tree layout nesting levels.
"
Class {
	#name : 'OPRSDependenciesMapBuilderTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Roassal-Tests-Meta',
	#package : 'OpenPonk-Roassal-Tests',
	#tag : 'Meta'
}

{ #category : 'tests' }
OPRSDependenciesMapBuilderTest >> testBuildMapForBaselineOfOpenPonk [
	| builder canvas |
	OPRSDependenciesMapBuilder resetOpenPonkBaselines.
	self assertCollection: OPRSDependenciesMapBuilder openPonkBaselines includesAll: #( #OpenPonk ).
	builder := OPRSDependenciesMapBuilder new.
	builder
		baseline: BaselineOfOpenPonk;
		build.
	canvas := builder canvas.
	self denyEmpty: canvas nodes.
	self denyEmpty: canvas lines
]

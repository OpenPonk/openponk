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
OPRSDependenciesMapBuilderTest >> testBaselineDominanceTreeLayoutFiltersOntoUMLProfileToClassEditorEdge [

	| layout profileNode classEditorNode otherNode |
	profileNode := RSBox new
		               model: (InstanceVariableSlot named: #BaselineOfOntoUMLProfile);
		               yourself.
	classEditorNode := RSBox new
		                   model: (InstanceVariableSlot named: #BaselineOfClassEditor);
		                   yourself.
	otherNode := RSBox new
		             model: (InstanceVariableSlot named: #BaselineOfOpenPonk);
		             yourself.
	layout := OPRSBaselineDominanceTreeLayout new.
	layout edges: {
			(RSLine new
				 from: profileNode;
				 to: classEditorNode;
				 yourself).
			(RSLine new
				 from: profileNode;
				 to: otherNode;
				 yourself) }.
	self assertEmpty: (layout parentsFor: classEditorNode).
	self assertCollection: (layout parentsFor: otherNode) hasSameElements: { profileNode }
]

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

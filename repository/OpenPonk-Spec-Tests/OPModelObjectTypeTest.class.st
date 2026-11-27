"
Verifies OPModelObjectType hierarchy comparison, printing, and tree node matching in OPModelObjectTypeAbstractNode subclasses.
"
Class {
	#name : 'OPModelObjectTypeTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'tests' }
OPModelObjectTypeTest >> testModelObjectTypeComparisonAndPrinting [

	| subA subB typeA typeA2 typeB |
	subA := OPModelObjectType named: 'Kind'.
	subB := OPModelObjectType named: 'Subkind'.
	typeA := OPModelObjectType named: 'Class' withSubtypes: {
			         subB.
			         subA }.
	typeA2 := OPModelObjectType named: 'Class' withSubtypes: {
			          subA.
			          subB }.
	typeB := OPModelObjectType named: 'Association' withSubtype: subA.
	self assert: typeA equals: typeA2.
	self assert: typeA hash equals: typeA2 hash.
	self assert: typeA hasSubtypes description: 'Type with subtypes should report hasSubtypes = true'.
	self deny: subA hasSubtypes description: 'Type without subtypes should report hasSubtypes = false'.
	self assert: typeB < typeA description: 'Association should sort before Class'.
	self assert: typeB <= typeA description: 'Association should be <= Class'.
	self assert: typeA > typeB description: 'Class should sort after Association'.
	self assert: typeA >= typeB description: 'Class should be >= Association'.
	self assert: (typeB min: typeA) equals: typeB.
	self assert: (typeB max: typeA) equals: typeA.
	self assert: (typeA between: typeB and: typeA) description: 'typeA should be between typeB and typeA'.
	self assert: (typeA includesNames: #( 'Class' 'Kind' )) description: 'Class with Kind subtype should include #(Class Kind)'.
	self deny: (typeA includesNames: #( 'Class' 'Role' )) description: 'Class without Role subtype should not include #(Class Role)'.
	self deny: (typeA includesNames: #( 'Package' )) description: 'Class type should not include #(Package)'.
	self assert: (typeA printWithNameSeparator: ': ' subtypesSeparator: ', ') equals: 'Class: Kind, Subkind'.
	self assert: typeA printString equals: 'an OPModelObjectType (Class)'
]

{ #category : 'tests' }
OPModelObjectTypeTest >> testTypeTreeNodeEqualityWithNonNodeObjects [

	| subKind classWithKind rootNode classNode kindLeaf nilValue |
	subKind := OPModelObjectType named: 'Kind'.
	classWithKind := OPModelObjectType named: 'Class' withSubtype: subKind.
	rootNode := OPModelObjectTypeRootNode withChildrenFromTypes: { classWithKind }.
	classNode := rootNode children first.
	kindLeaf := classNode children first.
	nilValue := nil.

	self deny: rootNode = nilValue description: 'Root type node must not equal nil'.
	self deny: rootNode = 'All' description: 'Root type node must not equal a String'.
	self deny: classNode = Object new description: 'Parent type node must not equal an unrelated object'.
	self deny: kindLeaf = 'Kind' description: 'Leaf type node must not equal a String'.
	self assert: classNode equals: classNode
]

{ #category : 'tests' }
OPModelObjectTypeTest >> testTypeTreeNodesComparisonAndRootOrdering [

	| subKind subRole classWithKind classWithRole simpleNote rootNode anotherRoot classNode noteNode kindLeaf |
	subKind := OPModelObjectType named: 'Kind'.
	subRole := OPModelObjectType named: 'Role'.
	classWithKind := OPModelObjectType named: 'Class' withSubtype: subKind.
	classWithRole := OPModelObjectType named: 'Class' withSubtype: subRole.
	simpleNote := OPModelObjectType named: 'Note'.
	rootNode := OPModelObjectTypeRootNode withChildrenFromTypes: {
			            classWithKind.
			            classWithRole.
			            simpleNote }.
	anotherRoot := OPModelObjectTypeRootNode new.
	classNode := rootNode children detect: [ :each | each name = 'Class' ].
	noteNode := rootNode children detect: [ :each | each name = 'Note' ].
	kindLeaf := classNode children detect: [ :each | each name = 'Kind' ].

	self assert: rootNode < classNode description: 'Root node must sort before its child'.
	self deny: classNode < rootNode description: 'Non-root node must not sort before root node'.
	self deny: rootNode < rootNode description: 'Root node comparison must be irreflexive'.
	self deny: rootNode < anotherRoot description: 'Root node must not sort before another root node'.
	self assert: rootNode <= rootNode description: 'Root node must be <= itself'.
	self assert: rootNode >= rootNode description: 'Root node must be >= itself'.
	self assert: classNode < noteNode description: 'Sibling Class must sort before Note'.
	self assert: noteNode < kindLeaf description: 'Shallower Note must sort before deeper Kind leaf'.
	self deny: kindLeaf < noteNode description: 'Deeper Kind leaf must not sort before shallower Note'
]

{ #category : 'tests' }
OPModelObjectTypeTest >> testTypeTreeNodesHierarchyAndMatching [
	| subKind subRole classWithKind classWithRole simpleNote rootNode classNode |
	subKind := OPModelObjectType named: 'Kind'.
	subRole := OPModelObjectType named: 'Role'.
	classWithKind := OPModelObjectType named: 'Class' withSubtype: subKind.
	classWithRole := OPModelObjectType named: 'Class' withSubtype: subRole.
	simpleNote := OPModelObjectType named: 'Note'.
	rootNode := OPModelObjectTypeRootNode withChildrenFromTypes: { classWithKind . classWithRole . simpleNote }.
	self assert: rootNode name equals: 'All'.
	self assertEmpty: rootNode namesFromRoot.
	self
		deny: rootNode isLeaf
		description: 'Root type node should not be a leaf'.
	self assert: rootNode children size equals: 2.
	self assert: rootNode withAllChildren size equals: 5.
	self assert: rootNode types size equals: 3.
	classNode := rootNode children detect: [ :each | each name = 'Class' ].
	self
		deny: classNode isLeaf
		description: 'Parent type node with subtypes should not be a leaf'.
	self assert: classNode namesFromRoot equals: #('Class').
	self
		assert: (classNode matchesType: classWithKind)
		description: 'Class node should match Class with Kind subtype'.
	self
		deny: (classNode matchesType: simpleNote)
		description: 'Class node should not match Note type'.
	self
		assert: classNode children first isLeaf
		description: 'Subtype leaf node should report isLeaf = true'.
	self
		assert: (classNode children first matchesType: classWithKind)
		description: 'First child leaf (Kind) should match Class with Kind subtype'
]

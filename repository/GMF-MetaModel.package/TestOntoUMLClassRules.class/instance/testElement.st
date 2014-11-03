running
testElement
	| part1 part2 whole1 whole2 |
	part1 := Kind name: 'Part1' metaModel: metaModel.
	part2 := Kind name: 'Part2' metaModel: metaModel.
	whole1 := Kind name: 'Whole1' metaModel: metaModel.
	whole2 := Kind name: 'Whole2' metaModel: metaModel.
	
	Meronymic name: 'TestMeronymic1' start: part1 startMultiplicity: '1' end: whole1 endMultiplicity: '1'.
	Meronymic name: 'TestMeronymic2' start: part2 startMultiplicity: '1' end: whole1 endMultiplicity: '1'.
	Meronymic name: 'TestMeronymic3' start: part1 startMultiplicity: '1' end: whole2 endMultiplicity: '1'.
	
	self deny: part1 isElementValid & part2 isElementValid.
	
	( part1 searchAssociation: 'TestMeronymic1' ) sharable: true.
	( part1 searchAssociation: 'TestMeronymic3' ) sharable: true.
	
	self assert: part1 isElementValid
	
tests
testSaveProjectEmpty
	| root store |
	root := FileSystem memory / 'project.opp'.
	self deny: root exists.
	controller saveProjectTo: root.
	self assert: root exists.
	store := (FileSystem zip: root) open.
	self assert: (store / 'project.json') exists
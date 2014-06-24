building
buildHeader
	self line: 'digraph generatedGraph {'.
	self
		indent;
		string: 'rankdir=LR';
		endLine.
	self
		indent;
		string: 'node [shape=box, style=rounded]';
		endLine
menu
menuCommandOn: aBuilder
	<worldMenu>
	(Pragma allNamed: #example: in: self class)
		do: [ :each |
			(aBuilder item: each arguments first)
				parent: #MostUsedTools;
				action: [ self perform: each method selector ] ]
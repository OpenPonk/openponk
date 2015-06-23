private - collecting
collectFiguresByClass: aClass
	<skipRule: #RBBadMessageRule>
	^ diagramController controllers select: [ :each | each isKindOf: aClass ] thenCollect: [ :each | each figure ]
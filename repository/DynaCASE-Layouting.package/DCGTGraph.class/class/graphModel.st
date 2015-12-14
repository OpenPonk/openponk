as yet unclassified
graphModel
	'
DCGTGraph { }
DCGTEdge { }
DCGTNode { }

DCGTNode[1] from <>-> edges DCGTEdge[*];
DCGTNode[1] to <>-> edges DCGTEdge[*];

DCGTGraph --> nodes DCGTNode[*];
DCGTGraph --> edges DCGTEdge[*];


' asClassDiagram open
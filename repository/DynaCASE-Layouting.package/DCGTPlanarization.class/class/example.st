as yet unclassified
example
	| a b c d e g ord pi part over parts |
	a := DCGTNode model: #A.
b := DCGTNode model: #B.
c := DCGTNode model: #C.
d := DCGTNode model: #D.
e := DCGTNode model: #E.

g := DCGTGraph new.
g addNode: a; addNode: b; addNode: c; addNode: d; addNode: e.

{
a -> d.
a -> c.
b -> c.
b -> d.
c -> d.
c -> e.
} do: [ :pair | g addEdge: (DCGTEdge from: pair key to: pair value) ].

ord := DCGTVertexOrdering new.
pi := ord orderingFor: g.

part := DCGTPartitioner new.

over := part overlapGraphFor: g ordering: pi.

parts := part partition: g ordering: pi.

parts third
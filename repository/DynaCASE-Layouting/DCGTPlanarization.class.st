"
Implementation of the two-phase Goldschmidt/Takvorian planarization.

!! Notes

The first phase of the algorithm is pluggable, thus it can either utilize the original [1], or mixed/upward extensions from [2].

!! Description

See

[1] M. G. Resende and C. C. Ribeiro, “A GRASP for graph planarization,” Networks, vol. 29, no. 3, pp. 173–189, 1997.

[2] M. E. F. E. M. Kaufmann, “An Approach for Mixed Upward Planarization,” Graph Algorithms and Applications 4, vol. 4, p. 203, 2006.
"
Class {
	#name : 'DCGTPlanarization',
	#superclass : 'Object',
	#category : 'DynaCASE-Layouting-DGT',
	#package : 'DynaCASE-Layouting',
	#tag : 'DGT'
}

{ #category : 'as yet unclassified' }
DCGTPlanarization class >> example [
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
]

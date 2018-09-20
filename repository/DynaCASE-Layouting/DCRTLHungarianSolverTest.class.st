Class {
	#name : #DCRTLHungarianSolverTest,
	#superclass : #TestCase,
	#instVars : [
		'solver',
		'matrix',
		'expected'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #'instance creation' }
DCRTLHungarianSolverTest >> matrixFor: a2DArray [
	^ Matrix
		rows: a2DArray size
		columns: a2DArray anyOne size
		tabulate: [ :i :j | (a2DArray at: i) at: j ]
]

{ #category : #running }
DCRTLHungarianSolverTest >> setUp [
	super setUp.
	solver := DCRTLHungarianSolver new
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testMedium [
	matrix := self
		matrixFor:
			{#(1 2 3 4).
			#(2 4 6 8).
			#(3 6 9 12).
			#(4 8 12 16)}.
	expected := {(#(1 4) -> 4).
	(#(2 3) -> 6).
	(#(3 2) -> 6).
	(#(4 1) -> 4)}.
	self assert: (solver solve: matrix) equals: expected
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testMicro [
	matrix := self matrixFor: {#(1)}.
	expected := {(#(1 1) -> 1)}.
	self assert: (solver solve: matrix) equals: expected
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testMini [
	matrix := self
		matrixFor:
			{#(1 3).
			#(5 9)}.
	expected := {(#(1 2) -> 3).
	(#(2 1) -> 5)}.
	self assert: (solver solve: matrix) equals: expected
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testPadWithZeros [
	matrix := self matrixFor: #(#(1 3)).
	expected := self matrixFor: #(#(1 3) #(0 0)).
	self assert: (solver padWithZeros: matrix) equals: expected
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testPadWithZeros2 [
	matrix := self matrixFor: #(#(1) #(2)).
	expected := self matrixFor: #(#(1 0) #(2 0)).
	self assert: (solver padWithZeros: matrix) equals: expected
]

{ #category : #tests }
DCRTLHungarianSolverTest >> testSmall [
	matrix := self
		matrixFor:
			{#(1 2 5).
			#(6 4 9).
			#(3 7 8)}.
	expected := {(#(1 3) -> 5).
	(#(2 2) -> 4).
	(#(3 1) -> 3)}.
	self assert: (solver solve: matrix) equals: expected
]

"
I solve minimal cost assignment problem as described in 
MUNKRES, J. Algorithms for the assignment and transportation problems. Journal of the Society for Industrial and Applied Mathematics 5, 1 (March 1957), 32–38
"
Class {
	#name : #DCRTLHungarianSolver,
	#superclass : #Object,
	#instVars : [
		'matrix',
		'marks',
		'size',
		'rowCovers',
		'columnCovers'
	],
	#category : 'DynaCASE-Layouting-GlobalEdgeLabels'
}

{ #category : #helpers }
DCRTLHungarianSolver >> addToColumnAt: j value: aValue [
	matrix atColumn: j put: ((matrix atColumn: j) collect: [ :each | each + aValue ])
]

{ #category : #helpers }
DCRTLHungarianSolver >> addToRowAt: i value: aValue [
	matrix atRow: i put: ((matrix atRow: i) collect: [ :each | each + aValue ])
]

{ #category : #helpers }
DCRTLHungarianSolver >> anyNonCoveredZero [
	matrix
		withIndicesDo:
			[ :val :i :j | 
			val = 0 & (rowCovers at: i) not & (columnCovers at: j) not
				ifTrue: [ ^ i @ j ] ].
	^ nil
]

{ #category : #helpers }
DCRTLHungarianSolver >> columnAt: j has: aMark [
	(marks atColumn: j)
		withIndexDo: [ :each :i | 
			each = aMark
				ifTrue: [ ^ i ] ].
	^ nil
]

{ #category : #helpers }
DCRTLHungarianSolver >> columnHasStar: j [
	^ self columnAt: j has: self star
]

{ #category : #helpers }
DCRTLHungarianSolver >> done [
	
]

{ #category : #constants }
DCRTLHungarianSolver >> empty [
	^ #empty
]

{ #category : #private }
DCRTLHungarianSolver >> initialMarks [
	matrix
		withIndicesDo:
			[ :value :row :column | 
			value = 0 & (rowCovers at: row) not & (columnCovers at: column) not
				ifTrue:
					[ marks at: row at: column put: self star.
					rowCovers at: row put: true.
					columnCovers at: column put: true ] ].
	rowCovers atAllPut: false
]

{ #category : #helpers }
DCRTLHungarianSolver >> isComplete [
	^ (columnCovers select: [ :each | each = true ]) size = size
]

{ #category : #private }
DCRTLHungarianSolver >> minimizeColumns [
	1 to: size do: [ :j | self addToColumnAt: j value: (matrix atColumn: j) min negated ]
]

{ #category : #private }
DCRTLHungarianSolver >> minimizeRows [
	1 to: size do: [ :i | self addToRowAt: i value: (matrix atRow: i) min negated ]
]

{ #category : #helpers }
DCRTLHungarianSolver >> nonCoveredMin [
	| min |
	min := Float infinity.
	matrix
		withIndicesDo:
			[ :val :i :j | 
			(rowCovers at: i) not & (columnCovers at: j) not & (val < min)
				ifTrue: [ min := val ] ].
	^ min
]

{ #category : #helpers }
DCRTLHungarianSolver >> padWithZeros: aMatrix [
	| max padded |
	max := aMatrix numberOfRows max: aMatrix numberOfColumns.
	padded := Matrix rows: max columns: max element: 0.
	aMatrix withIndicesDo: [ :value :row :col | padded at: row at: col put: value ].
	^ padded
]

{ #category : #public }
DCRTLHungarianSolver >> paddedSolve: aMatrix [
	| padded |
	padded := self padWithZeros: aMatrix.
	self solve: padded.
	^ self solution: aMatrix
]

{ #category : #constants }
DCRTLHungarianSolver >> prime [
	^ #prime
]

{ #category : #helpers }
DCRTLHungarianSolver >> resetCovers [
	rowCovers := (Array new: size) atAllPut: false.
	columnCovers := (Array new: size) atAllPut: false
]

{ #category : #helpers }
DCRTLHungarianSolver >> rowAt: i has: aMark [
	(marks atRow: i)
		withIndexDo: [ :each :j | 
			each = aMark
				ifTrue: [ ^ j ] ].
	^ nil
]

{ #category : #helpers }
DCRTLHungarianSolver >> rowHasStar: i [
	^ self rowAt: i has: self star
]

{ #category : #private }
DCRTLHungarianSolver >> setup [
	size := matrix numberOfRows.
	marks := Matrix rows: size columns: size element: self empty.
	self resetCovers
]

{ #category : #helpers }
DCRTLHungarianSolver >> solution: sourceMatrix [
	| solution |
	solution := OrderedCollection new.
	sourceMatrix
		withIndicesDo:
			[ :value :row :col | 
			(marks at: row at: col) = self star
				ifTrue: [ solution add: (Array with: row with: col) -> value ] ].
	^ solution asArray
]

{ #category : #public }
DCRTLHungarianSolver >> solve: aMatrix [
	self
		assert: [ aMatrix numberOfRows = aMatrix numberOfColumns ]
		description: 'aMatrix must be a square, or use #paddedSolve:'.
	matrix := aMatrix copy.
	self setup.
	self minimizeRows.
	self minimizeColumns.
	self initialMarks.
	self step1.
	^ self solution: aMatrix
]

{ #category : #constants }
DCRTLHungarianSolver >> star [
	^ #star
]

{ #category : #algorithm }
DCRTLHungarianSolver >> step1 [
	| indices |
	self isComplete
		ifTrue: [ ^ self done ].
	[ indices := self anyNonCoveredZero ]
		whileNotNil:
			[ marks at: indices x at: indices y put: self prime.
			(self rowHasStar: indices x)
				ifNil: [ ^ self step2: indices ]
				ifNotNil: [ :j | 
					rowCovers at: indices x put: true.
					columnCovers at: j put: false ] ].
	self step3
]

{ #category : #algorithm }
DCRTLHungarianSolver >> step2: aPrimeIndices [
	| path |
	path := OrderedCollection new.
	path add: aPrimeIndices.
	[ self columnAt: path last y has: self star ]
		whileNotNil:
			[ path add: (self columnAt: path last y has: self star) @ path last y.
			path add: path last x @ (self rowAt: path last x has: self prime) ].
	path
		do:
			[ :each | 
			(marks at: each x at: each y) = self star
				ifTrue: [ marks at: each x at: each y put: self empty ].
			(marks at: each x at: each y) = self prime
				ifTrue: [ marks at: each x at: each y put: self star ] ].
	self resetCovers.
	marks
		withIndicesDo:
			[ :each :row :col | 
			each = self prime
				ifTrue: [ marks at: row at: col put: self empty ].
			each = self star
				ifTrue: [ columnCovers at: col put: true ] ].
	self isComplete
		ifTrue: [ ^ self ].
	self step1
]

{ #category : #algorithm }
DCRTLHungarianSolver >> step3 [
	| min |
	min := self nonCoveredMin.
	rowCovers
		withIndexDo: [ :covered :i | 
			covered
				ifTrue: [ self addToRowAt: i value: min ] ].
	columnCovers
		withIndexDo:
			[ :covered :j | 
			covered
				ifFalse: [ self addToColumnAt: j value: min negated ] ].
	self step1
]

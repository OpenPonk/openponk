Class {
	#name : 'OPPackageBoundaryTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'asserting' }
OPPackageBoundaryTest >> assertPackageNamed: aPackageName doesNotDependOnRepositories: aCollectionOfRepositories [
	"Asserts that the specified package does not reference or subclass any entity from forbidden repositories."
	| violations |
	violations := self violationsInPackageNamed: aPackageName forbiddenRepositories: aCollectionOfRepositories.
	self
		assert: violations isEmpty
		description: [
			String streamContents: [ :stream |
				stream << 'Package ' << aPackageName << ' has forbidden repository dependencies:'; cr.
				violations do: [ :eachViolation |
					stream << '  - ' << eachViolation; cr ] ] ]
]

{ #category : 'private' }
OPPackageBoundaryTest >> checkMethod: aCompiledMethod againstForbiddenRepositories: aSetOfRepositories repositoryMap: aDictionary into: aViolationsCollection [
	"Checks a compiled method and all its nested compiled blocks for literals referencing behaviors from forbidden repositories."

	| codeUnitsToInspect currentCodeUnit |
	codeUnitsToInspect := OrderedCollection with: aCompiledMethod.
	[ codeUnitsToInspect notEmpty ] whileTrue: [
			currentCodeUnit := codeUnitsToInspect removeFirst.
			codeUnitsToInspect addAll: (currentCodeUnit literals select: [ :eachLiteral |
						 eachLiteral isVariableBinding ifTrue: [
								 | bindingValue |
								 bindingValue := eachLiteral value.
								 (bindingValue isBehavior and: [ bindingValue instanceSide package isNotNil ]) ifTrue: [
										 (aDictionary at: bindingValue instanceSide package name asString ifAbsent: [ nil ]) ifNotNil: [ :targetRepository |
												 (aSetOfRepositories includes: targetRepository) ifTrue: [
														 aViolationsCollection add:
															 aCompiledMethod printString , ' references ' , bindingValue name asString , ' from ['
															 , targetRepository name asString , ']' ] ] ] ].
						 (eachLiteral isKindOf: CompiledCode) ifTrue: [ codeUnitsToInspect add: eachLiteral ].
						 eachLiteral isKindOf: BlockClosure ]) ]
]

{ #category : 'accessing' }
OPPackageBoundaryTest >> genericRepositories [
	"Answers all OpenPonk repositories representing core framework and generic tools."
	| notationRepos |
	notationRepos := self notationRepositories.
	^ self openPonkRepositories reject: [ :eachRepository |
		notationRepos includes: eachRepository ]
]

{ #category : 'testing' }
OPPackageBoundaryTest >> isBaseUmlRepository: anIceRepository [
	"Answers true if the repository belongs to the core UML notation or its metamodel libraries."
	| repositoryName |
	repositoryName := anIceRepository name asLowercase.
	^ #( 'class-editor' 'uml-metamodel' 'uml-xmi' 'uml-profiles' 'uml-bootstrap-generator' )
		anySatisfy: [ :eachBaseName | repositoryName includesSubstring: eachBaseName ]
]

{ #category : 'testing' }
OPPackageBoundaryTest >> isNotationRepository: anIceRepository [
	"Answers true if the repository represents a concrete domain notation or notation extension."
	| repositoryPackages |
	repositoryPackages := anIceRepository workingCopy packages collect: [ :eachWorkingCopyPackage |
		eachWorkingCopyPackage packageName ].
	(self isBaseUmlRepository: anIceRepository) ifTrue: [ ^ true ].
	(self isOntoUmlRepository: anIceRepository) ifTrue: [ ^ true ].
	^ OPPlugin allSubclasses anySatisfy: [ :eachPluginClass |
		eachPluginClass isTestingOnly not and: [
			eachPluginClass package ifNotNil: [ :eachPackage |
				repositoryPackages includes: eachPackage name asString ] ifNil: [ false ] ] ]
]

{ #category : 'testing' }
OPPackageBoundaryTest >> isOntoUmlRepository: anIceRepository [
	"Answers true if the repository belongs to the OntoUML profile family."
	^ anIceRepository name asLowercase includesSubstring: 'ontouml'
]

{ #category : 'testing' }
OPPackageBoundaryTest >> isUmlFamilyRepository: anIceRepository [
	"Answers true if the repository belongs to the UML or OntoUML notation family."
	| repositoryName |
	repositoryName := anIceRepository name asLowercase.
	^ (repositoryName includesSubstring: 'uml')
		or: [ repositoryName includesSubstring: 'ontouml' ]
]

{ #category : 'accessing' }
OPPackageBoundaryTest >> notationRepositories [
	"Answers all OpenPonk repositories representing notations and their extensions."
	^ self openPonkRepositories select: [ :eachRepository |
		self isNotationRepository: eachRepository ]
]

{ #category : 'accessing' }
OPPackageBoundaryTest >> openPonkRepositories [
	"Answers all IceRepository instances that contain OpenPonk packages."
	^ IceRepository registry select: [ :eachRepository |
		eachRepository workingCopy packages anySatisfy: [ :eachPackage |
			eachPackage packageName beginsWith: 'OpenPonk' ] ]
]

{ #category : 'accessing' }
OPPackageBoundaryTest >> packageToRepositoryMap [
	"Answers a dictionary mapping package names to their IceRepository."
	| repositoryMap |
	repositoryMap := Dictionary new.
	IceRepository registry do: [ :eachRepository |
		eachRepository workingCopy packages do: [ :eachPackage |
			repositoryMap at: eachPackage packageName put: eachRepository ] ].
	^ repositoryMap
]

{ #category : 'tests' }
OPPackageBoundaryTest >> testGenericRepositoriesDoNotDependOnNotations [
	"Verifies that generic tools and core repositories do not reference any notation repository."
	| notationRepos genericRepos violations |
	notationRepos := self notationRepositories.
	genericRepos := self genericRepositories.
	violations := OrderedCollection new.

	genericRepos do: [ :eachGenericRepository |
		violations addAll: (self violationsInRepository: eachGenericRepository forbiddenRepositories: notationRepos) ].

	self
		assert: violations isEmpty
		description: [
			String streamContents: [ :stream |
				stream << 'Generic repositories have forbidden dependencies on notations:'; cr.
				violations do: [ :eachViolation |
					stream << '  - ' << eachViolation; cr ] ] ]
]

{ #category : 'tests' }
OPPackageBoundaryTest >> testNotationRepositoriesDoNotDependOnPeerNotations [
	"Verifies that each notation repository does not reference any other peer notation repository."
	| notationRepos violations |
	notationRepos := self notationRepositories.
	violations := OrderedCollection new.

	notationRepos do: [ :eachNotationRepository |
		| forbiddenRepositories |
		forbiddenRepositories := (notationRepos copyWithout: eachNotationRepository) asSet.
		(self isBaseUmlRepository: eachNotationRepository) ifTrue: [
			"Base UML may see other base UML repositories, but not OntoUML nor other notations."
			forbiddenRepositories := forbiddenRepositories reject: [ :eachCandidateRepository |
				self isBaseUmlRepository: eachCandidateRepository ] ].
		(self isOntoUmlRepository: eachNotationRepository) ifTrue: [
			"OntoUML may see base UML and other OntoUML repositories, but not peer notations."
			forbiddenRepositories := forbiddenRepositories reject: [ :eachCandidateRepository |
				(self isBaseUmlRepository: eachCandidateRepository)
					or: [ self isOntoUmlRepository: eachCandidateRepository ] ] ].

		violations addAll: (self violationsInRepository: eachNotationRepository forbiddenRepositories: forbiddenRepositories) ].

	self
		assert: violations isEmpty
		description: [
			String streamContents: [ :stream |
				stream << 'Notation repositories have forbidden dependencies on peer notations:'; cr.
				violations do: [ :eachViolation |
					stream << '  - ' << eachViolation; cr ] ] ]
]

{ #category : 'evaluating' }
OPPackageBoundaryTest >> violationsInPackageNamed: aPackageName forbiddenRepositories: aCollectionOfRepositories [
	"Answers an OrderedCollection of human-readable violation descriptions."
	| targetPackage repositoryMap forbiddenRepositories violations |
	targetPackage := self packageOrganizer packageNamed: aPackageName ifAbsent: [ ^ #() ].
	repositoryMap := self packageToRepositoryMap.
	forbiddenRepositories := aCollectionOfRepositories asSet.
	violations := OrderedCollection new.

	targetPackage definedClasses do: [ :eachDefinedClass |
		eachDefinedClass superclass ifNotNil: [ :superClass |
			superClass instanceSide package ifNotNil: [ :superPackage |
				(repositoryMap at: superPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :superRepository |
					(forbiddenRepositories includes: superRepository) ifTrue: [
						violations add: (eachDefinedClass name asString , ' subclasses ' , superClass name asString , ' from [' , superRepository name asString , ']') ] ] ] ].

		eachDefinedClass traits do: [ :usedTrait |
			usedTrait package ifNotNil: [ :traitPackage |
				(repositoryMap at: traitPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :traitRepository |
					(forbiddenRepositories includes: traitRepository) ifTrue: [
						violations add: (eachDefinedClass name asString , ' uses trait ' , usedTrait name asString , ' from [' , traitRepository name asString , ']') ] ] ] ].

		(eachDefinedClass methods , eachDefinedClass classSide methods) do: [ :eachMethod |
			self checkMethod: eachMethod againstForbiddenRepositories: forbiddenRepositories repositoryMap: repositoryMap into: violations ] ].

	targetPackage extensionMethods do: [ :eachExtensionMethod |
		eachExtensionMethod methodClass instanceSide package ifNotNil: [ :extendedPackage |
			(repositoryMap at: extendedPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :extendedRepository |
				(forbiddenRepositories includes: extendedRepository) ifTrue: [
					violations add: (eachExtensionMethod printString , ' extends class from [' , extendedRepository name asString , ']') ] ] ] ].

	^ violations
]

{ #category : 'evaluating' }
OPPackageBoundaryTest >> violationsInRepository: anIceRepository forbiddenRepositories: aCollectionOfRepositories [
	"Answers an OrderedCollection of violations found in all packages of the given repository."
	| repositoryMap forbiddenRepositories violations |
	repositoryMap := self packageToRepositoryMap.
	forbiddenRepositories := aCollectionOfRepositories asSet.
	violations := OrderedCollection new.

	anIceRepository workingCopy packages do: [ :eachWorkingCopyPackage |
		(self packageOrganizer packageNamed: eachWorkingCopyPackage packageName ifAbsent: [ nil ]) ifNotNil: [ :eachPackage |
			eachPackage definedClasses do: [ :eachDefinedClass |
				eachDefinedClass superclass ifNotNil: [ :superClass |
					superClass instanceSide package ifNotNil: [ :superPackage |
						(repositoryMap at: superPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :superRepository |
							(forbiddenRepositories includes: superRepository) ifTrue: [
								violations add: (eachDefinedClass name asString , ' subclasses ' , superClass name asString , ' from [' , superRepository name asString , ']') ] ] ] ].

				eachDefinedClass traits do: [ :usedTrait |
					usedTrait package ifNotNil: [ :traitPackage |
						(repositoryMap at: traitPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :traitRepository |
							(forbiddenRepositories includes: traitRepository) ifTrue: [
								violations add: (eachDefinedClass name asString , ' uses trait ' , usedTrait name asString , ' from [' , traitRepository name asString , ']') ] ] ] ] ].

			eachPackage methods do: [ :eachMethod |
				eachMethod isExtension ifTrue: [
					eachMethod methodClass instanceSide package ifNotNil: [ :extendedPackage |
						(repositoryMap at: extendedPackage name asString ifAbsent: [ nil ]) ifNotNil: [ :extendedRepository |
							(forbiddenRepositories includes: extendedRepository) ifTrue: [
								violations add: (eachMethod printString , ' extends class from [' , extendedRepository name asString , ']') ] ] ] ].
				self checkMethod: eachMethod againstForbiddenRepositories: forbiddenRepositories repositoryMap: repositoryMap into: violations ] ] ].

	^ violations
]

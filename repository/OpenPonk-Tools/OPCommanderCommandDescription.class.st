Class {
	#name : #OPCommanderCommandDescription,
	#superclass : #Object,
	#instVars : [
		'commandClass',
		'command'
	],
	#category : #'OpenPonk-Tools'
}

{ #category : #accessing }
OPCommanderCommandDescription >> command [
	^ command ifNil: [ command := self commandClass new ]
]

{ #category : #accessing }
OPCommanderCommandDescription >> commandClass [
	^ commandClass
]

{ #category : #accessing }
OPCommanderCommandDescription >> commandClass: aClass [
	commandClass := aClass
]

{ #category : #writing }
OPCommanderCommandDescription >> compileInfo: aSource [
	self commandClass compile: aSource withSqueakLineEndings classified: 'accessing'
]

{ #category : #writing }
OPCommanderCommandDescription >> compileInfo: aSource classified: aProtocol [
	self commandClass compile: aSource withSqueakLineEndings classified: aProtocol
]

{ #category : #descriptions }
OPCommanderCommandDescription >> descriptionDefaultMenuIcon [
	<magritteDescription>
	^ MAStringDescription new
		accessor:
			(MAPluggableAccessor
				read: [ :obj | obj readReturn: #defaultMenuIcon ]
				write: [ :obj :newValue | obj compileInfo: ('defaultMenuIcon<n><t>^ <1s>' expandMacrosWith: newValue) ]);
		label: 'Icon';
		priority: 1;
		yourself
]

{ #category : #descriptions }
OPCommanderCommandDescription >> descriptionDefaultMenuItemName [
	<magritteDescription>
	^ MAStringDescription new
		accessor:
			(MAPluggableAccessor
				read: [ :obj | obj readProperty: #defaultMenuItemName ]
				write: [ :obj :newValue | obj compileInfo: ('defaultMenuItemName<n><t>^ <1p>' expandMacrosWith: newValue) ]);
		label: 'Name';
		priority: 2;
		yourself
]

{ #category : #descriptions }
OPCommanderCommandDescription >> descriptionExecute [
	<magritteDescription>
	^ MAMemoDescription new
		accessor:
			(MAPluggableAccessor
				read: [ :obj | 
					((obj readBody: #execute) lines collect: [ :each | each withoutPrefix: String tab ])
						joinUsing: String cr ]
				write: [ :obj :newValue | 
					| body |
					body := (newValue lines collect: [ :each | String tab , each ]) joinUsing: String cr.
					obj compileInfo: ('execute<n><1s>' expandMacrosWith: body) ]);
		label: 'Execute';
		priority: 3;
		yourself
]

{ #category : #writing }
OPCommanderCommandDescription >> ensureRemoveSelector: aSelector [
	self commandClass removeSelector: aSelector
]

{ #category : #reading }
OPCommanderCommandDescription >> readBody: aKey [
	^ self command class methodDictionary
		at: aKey
		ifPresent: [ :method | 
			| node interval |
			node := method ast body.
			interval := node sourceInterval.
			node source copyFrom: interval first - 1 to: interval last ]
		ifAbsent: [ '' ]
]

{ #category : #reading }
OPCommanderCommandDescription >> readProperty: aKey [
	^ [ aKey value: self command ]
		on: SubclassResponsibility
		do: [ :e | '' ]
]

{ #category : #reading }
OPCommanderCommandDescription >> readReturn: aKey [
	^ self command class methodDictionary
		at: aKey
		ifPresent: [ :method | 
			| node |
			node := method ast body statements last.
			node isReturn
				ifTrue: [ | interval |
					interval := node sourceInterval.
					node source copyFrom: interval first + 2 to: interval last ]
				ifFalse: [ '' ] ]
		ifAbsent: [ '' ]
]

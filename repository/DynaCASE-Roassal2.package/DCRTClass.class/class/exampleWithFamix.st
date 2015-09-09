examples
exampleWithFamix
	| v e cls attr method param numberType stringType |
	v := RTView new.
	e := DCRTClass new.
	cls := FAMIXClass new.
	cls name: 'FAMIXClass'.
	(stringType := FAMIXClass new) name: 'String'.
	(numberType := FAMIXClass new) name: 'Number'.
	(attr := FAMIXAttribute new)
		name: 'first';
		declaredType: stringType.
	cls addAttribute: attr.
	method := FAMIXMethod new.
	method name: 'method'.
	param := FAMIXParameter new.
	param name: 'paramA'.
	param declaredType: stringType.
	method addParameter: param.
	cls addMethod: method.
	e
		name: cls name;
		attributes:
			(cls attributes collect: [ :each | each name , ' : ' , each declaredType name ]);
		methods:
			(cls methods
				collect:
					[ :each | 
					each name , '('
						,
							((each parameters collect: [ :p | p name , ' : ' , p declaredType name ]) joinUsing: ', ')
						, ')' ]).
	e renderIn: v.
	v open
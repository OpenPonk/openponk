accessing
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				project: 'Roassal2'
					with: [ 
							spec
								className: #ConfigurationOfRoassal2;
								versionString: #development;
								repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ];
				project: 'STON'
					with: [ 
							spec
								className: #ConfigurationOfSton;
								versionString: #stable;
								repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/STON/main/' ].
			spec
				package: 'DynaCASE';
				package: 'DynaCASE-FSM';
				package: 'DynaCASE-OntoUML';
				package: 'DynaCASE-Roassal2';
				package: 'DynaCASE-Spec';
				package: 'DynaCASE-Trachel';
				package: 'DynaCASE-Umlite';
				package: 'GMF-MetaModel' ]
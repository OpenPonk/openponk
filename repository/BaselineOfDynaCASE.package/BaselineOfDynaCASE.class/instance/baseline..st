accessing
baseline: spec
	<baseline>
	spec for: #'common' do: [
		spec 
			project: 'DynaCASE-Model' with: [ 
				spec
					baseline: 'DynaCASEModel' with: [ 
						spec repository: 'github://dynacase/dynacase-model'
					]
			];
			project: 'Roassal2' with: [
				spec
					className: #ConfigurationOfRoassal2;
					versionString: #'development';
					repository: 'http://smalltalkhub.com/mc/ObjectProfile/Roassal2/main/' ];
			project: 'Ston' with: [
				spec
					className: #ConfigurationOfSton;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/SvenVanCaekenberghe/STON/main/' ].
		spec 
			package: 'DynaCASE' with: [
				spec requires: #('DynaCASE-Model' 'Roassal2' 'Ston' ). ];
			package: 'DynaCASE-FSM';
			package: 'DynaCASE-OntoUML';
			package: 'DynaCASE-Roassal2';
			package: 'DynaCASE-Spec';
			package: 'DynaCASE-Trachel';
			package: 'DynaCASE-Umlite';
			package: 'GMF-MetaModel'.
		spec group: 'default' with: #('DynaCASE' 'DynaCASE-FSM' 'DynaCASE-OntoUML' 'DynaCASE-Roassal2' 'DynaCASE-Spec' 'DynaCASE-Trachel' 'DynaCASE-Umlite' 'GMF-MetaModel' ). ].

api - registration
register: aControllerClass forModel: aModelClass condition: aConditionBlock
	registrations
		add:
			(self registrationClass new
				controllerClass: aControllerClass;
				modelClass: aModelClass;
				condition: aConditionBlock)
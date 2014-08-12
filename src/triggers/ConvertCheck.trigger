trigger ConvertCheck on Lead (after update) 
{
	for (Integer i = 0; i < Trigger.new.size(); i++) 
	{
		if(Trigger.new[i].IsConverted)
		{
			Boolean bCanConvert = false;
			String strTaskName = 'WFT-Send Survey';
			for (Task task : [select Status from Task where WhoId = :Trigger.new[i].Id AND Subject = :strTaskName]) 
			{
				if(task.Status == 'Completed')
				{
					bCanConvert = true;
				}
			}
			if(!bCanConvert)
			{
				for (Opportunity oppty : [select Id from Opportunity where Id = :Trigger.new[i].ConvertedOpportunityId]) 
				{
					delete oppty;
				}
				Trigger.new[i].IsConverted = false;
				Trigger.new[i].addError('Can not convert to opportunity, if survey is not completed.');//throw error message.
			}
		}
	}
}
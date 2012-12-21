/**
 * Queries AWSKeys by record name from Custom Object in SFDC
 * Modified from Force.com AWS Toolkit Appexchange app to be a modified Singleton to avoid unneccessary DML calls
 * 
 * Original Source: http://aws.amazon.com/solutions/global-solution-providers/salesforce/
 * Updated By: Tom Gersic, 2-23-2011
 **/ 

public class AWSKeys {
	
	public class AWSKeysException extends Exception {}
	
	private static AWSKeys instance = null;
	
	AWSKey__c keyObj = null;
	public string key { get { return keyObj.key__c; } private set; }
	public string secret { get { return keyObj.secret__c; } private set; }
	public String name {get; set;}

	// constructor
	public AWSKeys() {
	
	}
	
	public static AWSKeys getInstance(String name)
	{
		if(instance==null || instance.name != name)
		{
			instance = new AWSKeys();
			instance.name = name;
			instance.getKeys();
		}
		return instance;  
	}
	
	private void getKeys()
	{
			try {
				keyObj = [select key__c,secret__c,id from AWSKey__c where name = :name limit 1]; 
				
				//Check that key__c is not null
				if(keyObj.key__c == null || keyObj.key__c == ''){
				   //ApexPages.addMessages();
				   ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No key is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Key value and retry.');
				   ApexPages.addMessage(errorMsg);
				   throw new AWSKeysException('Error: No key is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Key value and retry.'); 	
				}
				
				//Check that secret__c is not null
				if(keyObj.secret__c == null || keyObj.secret__c == ''){
				   ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Error: No secret is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Secret value and retry.');
				   ApexPages.addMessage(errorMsg);
				   throw new AWSKeysException('Error: No secret is specified for the AWSKey__c record with name of [' +name+']. Pleaes enter the Secret value and retry.'); 	
				}
				
			} catch (QueryException queryEx) {
				system.debug('Error when querying the AWSKey__c custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper AWS credentials and retry.');
				//ApexPages.addMessages(queryEx);
				throw new AWSKeysException('Error when querying the AWSKey__c custom object. Did not find any record with name of ['+name+']. Please make sure the name is correct or create a record with the proper AWS credentials and retry.');
				//keyObj = new AWSKey__c( key__c='not set', secret__c='not set' );
			} 
			//don't catch other exceptions, let them fall through to the calling class....
	}
	
	static testmethod void testInstance() {
		try{
			AWSKeys k = AWSKeys.getInstance('badname');
		}catch(AWSKeysException AWSExcept){
			system.debug('here: ' +AWSExcept.getTypeName());
		   	system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
		   	
		}
		
		AWSKey__c t1 = new AWSKey__c( key__c='s1', secret__c='s1', name='test' );
		insert t1;
		AWSKeys k = AWSKeys.getInstance('test');
		system.assert(k.key == 's1');
		system.assert(k.secret == 's1');
		
		
		try{
			AWSKey__c t2 = new AWSKey__c( secret__c='s1', name='test2' );
			insert t2;
			k = AWSKeys.getInstance('test2');
		}catch(AWSKeysException AWSExcept){
		   	system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
		   	
		}
		
		try{
			AWSKey__c t3 = new AWSKey__c( key__c='s1', name='test3' );
			insert t3;
			k = AWSKeys.getInstance('test3');
		}catch(AWSKeysException AWSExcept){
		   	system.assert(AWSExcept.getTypeName().contains('AWSKeys.AWSKeysException'));
		   	
		}
		
				
	}
	

}
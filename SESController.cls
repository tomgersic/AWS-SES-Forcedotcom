/**
 * Dummy controller for a VF Page. Sends a test message
 *
 * Author: Tom Gersic, Model Metrics
 **/

public with sharing class SESController {

	private String AWSCredentialName = 'tom';

      public PageReference constructor(){
    	try{
			
			AWSKeys awsKey = AWSKeys.getInstance(AWSCredentialName);
			SES sesEmail = new SES(awsKey.key,awsKey.secret);
			
			List<String> recipients = new List<String>();
			recipients.add('tgersic@modelmetrics.com'); 
			String sender = 'tgersic@modelmetrics.com';
			String subject = 'Test message';
			String body = 'This is the body of the message';
			
			sesEmail.sendEmail(recipients,sender,subject,body);
		
		}catch(AWSKeys.AWSKeysException AWSEx){
		     
		     ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
			 ApexPages.addMessage(errorMsg);
			    
		}
		
		
		
    
       return null;	
    }

}
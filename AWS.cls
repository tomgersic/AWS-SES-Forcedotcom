/**
 * AWS Methods necessary for any AWS service
 *
 * Author: Tom Gersic, Model Metrics
 **/

public with sharing abstract class AWS {
	public string secret { get; set; }
	public string key { get; set; }
	
	/**
	 * Generate signature per AWS documentation
	 * http://docs.amazonwebservices.com/ses/latest/DeveloperGuide/index.html?HMACShaSignatures.html
	 **/
	 		
	public string signature(String awsNow, String secret) {
		system.assert( secret != null ,' missing S3.secret key');
		Blob bsig = Crypto.generateMac('HmacSHA256', Blob.valueOf(awsNow), Blob.valueOf(secret));          
		return EncodingUtil.base64Encode(bsig); 
	} 
	
	/**
	 * Date formatted per AWS documentation
	 * format should be  Tue, 25 May 2010 21:20:27 +0000
	 * http://docs.amazonwebservices.com/ses/latest/DeveloperGuide/index.html?HMACShaSignatures.html
	 **/
	public string awsFormattedDate(Datetime now)
	{
		return  now.formatGmt('EEE, d MMM yyyy HH:mm:ss Z');           
	}

	/**
	 * Create a X-Amzn-Authorization Header
	 * X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=<Your AWS Access Key ID>, Algorithm=HmacSHA256, Signature=<Signature>
	 **/
	 
	public string headerForAmazonAuthorization(String accessKey, String signature)
	{
		return 'AWS3-HTTPS AWSAccessKeyId='+accessKey+', Algorithm=HmacSHA256, Signature='+signature;
	}
}
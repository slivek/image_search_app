public with sharing class ImageSearchLightningComponentController {
    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static List<Object> fetchData() {
        return (List<Object>)[SELECT Url, Title FROM Image];
    }

    @AuraEnabled
    public static boolean sendEmail(String images, String email){
        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        sendTo.add(email);
        mail.setToAddresses(sendTo);
        mail.setSenderDisplayName('salesforce User');
        mail.setSubject('Images');
        mail.setHtmlBody(images);
        mails.add(mail);
        Messaging.sendEmail(mails);
        return true;
    }
}

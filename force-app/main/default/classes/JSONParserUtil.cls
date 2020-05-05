public class JSONParserUtil {
    @future(callout=true)
    public static void parseJSONResponse() {        
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        String endpoint = 'https://jsonplaceholder.typicode.com/photos';
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        System.debug(response.getBody());
        /* The JSON response returned is the following:
        String s = '{"invoiceList":[' +
        '{"totalPrice":5.5,"statementDate":"2011-10-04T16:58:54.858Z","lineItems":[' +
            '{"UnitPrice":1.0,"Quantity":5.0,"ProductName":"Pencil"},' +
            '{"UnitPrice":0.5,"Quantity":1.0,"ProductName":"Eraser"}],' +
                '"invoiceNumber":1},' +
        '{"totalPrice":11.5,"statementDate":"2011-10-04T16:58:54.858Z","lineItems":[' +
            '{"UnitPrice":6.0,"Quantity":1.0,"ProductName":"Notebook"},' +
            '{"UnitPrice":2.5,"Quantity":1.0,"ProductName":"Ruler"},' +
            '{"UnitPrice":1.5,"Quantity":2.0,"ProductName":"Pen"}],"invoiceNumber":2}' +
        ']}'; 
        */

        // Parse JSON response to get all the totalPrice field values.
        JSONParser parser = JSON.createParser(response.getBody());
        List<Photo> photos = new List<Photo>();
        while (parser.nextToken() != null) {
            // Start at the array of invoices.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next invoice statement object.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of line items.
                        Photo img = (Photo)parser.readValueAs(Photo.class);
                        system.debug('photo number: ' + img.id);
                        // For debugging purposes, serialize again to verify what was parsed.
                        String s = JSON.serialize(img);
                        system.debug('Serialized photos: ' + s);
                        photos.add(img);
                        // Skip the child start array and start object markers.
                        parser.skipChildren();
                    }
                }
            }
        }
        removeOldImages();
        insertImages(photos);
    }

    private static void removeOldImages(){
        List<Image> imagesToRemove = [SELECT Id FROM Image];
        delete imagesToRemove;
    }

    private static void insertImages(List<Photo> photos){
        List<Image> imagesToInsert = new List<Image>();
        for(Photo photo : photos){
            Image loopImage = new Image();
            loopImage.Title = photo.title;
            loopImage.Url = photo.url;
            imagesToInsert.add(loopImage);
        }
        system.debug(imagesToInsert);
        insert imagesToInsert;
    }

    public class Photo {
        public Integer albumId;
        public Integer id;
        public String title;
        public String url;
        public String thumbnailUrl; 
        
        public Photo(Integer albumId, Integer id, String title, String url, String thumbnailUrl) {
            this.albumId = albumId;
            this.id = id;
            this.title = title;
            this.url = url;
            this.thumbnailUrl = thumbnailUrl;
        }
    }
}
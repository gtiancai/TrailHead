@IsTest
public without sharing class WarehouseCalloutServiceMock implements HttpCalloutMock{
    private String strResponseBody;
    private Integer intStatusCode;

    public WarehouseCalloutServiceMock(String strResponseBody, Integer intStatusCode) {
        this.strResponseBody = strResponseBody;
        this.intStatusCode = intStatusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.strResponseBody);
        res.setStatusCode(this.intStatusCode);
        return res;
    }
}

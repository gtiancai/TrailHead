@IsTest
public without sharing class ProjectCalloutServiceMock implements HttpCalloutMock {
    private String strResponse;
    private String status;
    private Integer statusCode;
    public ProjectCalloutServiceMock(String strResponse, String status, Integer statusCode) {
        this.strResponse = strResponse;
        this.status = status;
        this.statusCode = statusCode;
    }

    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.strResponse);
        res.setStatusCode(this.statusCode);
        res.setStatus(this.status);

        return res;
    }
}

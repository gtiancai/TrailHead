@IsTest
public without sharing class BillingCalloutServiceMockFailure implements WebServiceMock {
    private String respBody;
    private String status;
    private Integer statusCode;

    public BillingCalloutServiceMockFailure(String respBody, String status, Integer statusCode) {
        this.respBody = respBody;
        this.status = status;
        this.statusCode = statusCode;
    }

    // public HttpResponse respond(HttpRequest req) {
    //     HttpResponse resp = new HttpResponse();
    //     resp.setBody(this.respBody);
    //     resp.setStatus(this.status);
    //     resp.setStatusCode(this.statusCode);
    //     resp.setHeader('ContentType', 'application/JSON');

    //     return resp;
    // }

    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            BillingServiceProxy.billProjectResponse_element respElement =
                    new BillingServiceProxy.billProjectResponse_element();
            respElement.status = 'Failure';
            response.put('response_x', respElement);
        }
}

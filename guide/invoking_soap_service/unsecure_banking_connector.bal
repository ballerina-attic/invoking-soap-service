import wso2/soap;
import ballerina/io;

endpoint soap:Client soapClient {
    clientConfig: {
        url: "http://localhost:9000"
    }
};

public function unsecureBankingConnector(string soapAction, xml soapBody) returns soap:SoapResponse|soap:SoapError {
    soap:SoapRequest soapRequest = {
        soapAction: soapAction,
        payload: soapBody
    };

    var soapResp = soapClient->sendReceive("/services/UnsecureBankingService", soapRequest);
    return soapResp;
}

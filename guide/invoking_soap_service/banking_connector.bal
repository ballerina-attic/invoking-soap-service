import ballerina/io;
import wso2/soap;

//This client is used to connect with secure and unsecure soap backends and exchange data
public function main(string... args) {
    xml payload = xml `<m0:getAccountDetails xmlns:m0="http://services.samples">
                            <m0:request>
                                <m0:accountNo>2417254</m0:accountNo>
                            </m0:request>
                        </m0:getAccountDetails>`;
    var unsecureSoapResp = unsecureBankingConnector("urn:getAccountDetails", payload);
    match unsecureSoapResp {
        soap:SoapResponse soapResponse => io:println(soapResponse.payload);
        soap:SoapError soapError => io:println(soapError);
    }

//    var secureSoapResp = secureBankingConnector();
//    match secureSoapResp {
//       soap:SoapResponse soapResponse => io:println(soapResponse);
//       soap:SoapError soapError => io:println(soapError);
//    }
}

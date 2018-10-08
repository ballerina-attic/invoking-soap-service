import wso2/soap;
import ballerina/io;

public function secureBankingConnector() returns soap:SoapResponse|soap:SoapError {
   xml body = xml `<m0:getAccountDetails xmlns:m0="http://services.samples">
                       <m0:account>
                           <m0:accountNo>2417254</m0:accountNo>
                       </m0:account>
                   </m0:getAccountDetails>`;

    //xml header = xml `<userName>Seran</userName>`;
    xml header = xml `<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd">
            <wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="UsernameToken-4055741">
                <wsse:Username>wso2ballerina</wsse:Username>
                <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">
                    wso2ballerina
                </wsse:Password>
            </wsse:UsernameToken>
        </wsse:Security>`;

   soap:SoapRequest soapRequest = {
       soapAction: "urn:getAccountDetails",
       headers: [header],
       payload: body
   };


   var soapResp = soapClient->sendReceive("/services/SecureBankingService", soapRequest);
   return soapResp;
}

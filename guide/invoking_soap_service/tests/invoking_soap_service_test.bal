import ballerina/io;
import ballerina/test;
import wso2/soap;
import ballerina/http;

xmlns "http://services.samples" as ns;
xmlns "http://services.samples/xsd" as axis;
// xmlns "http://www.w3.org/2001/12/soap-encoding" as soapenc;
// xmlns "http://schemas.xmlsoap.org/soap/envelope/" as soapenv;
// xmlns "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" as wsse;
// xmlns "http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" as wsu;

// endpoint http:Client clientEP {
//     url:"http://localhost:9091"
// };

@test:Config
function getAccountDetails() {
    io:println("Running the test for : Fetching account details");
    xml getReq =   xml `<m0:getAccountDetails xmlns:m0="http://services.samples">
                            <m0:request>
                                <m0:accountNo>2417254</m0:accountNo>
                            </m0:request>
                        </m0:getAccountDetails>`;

    // xml expGetResp =    xml `<ns:getAccountDetailsResponse xmlns:ns="http://services.samples">
    //                             <ns:return xmlns:ax25="http://services.samples/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ax25:AccountDetails">
    //                                 <ax25:accountBalance>250000.0</ax25:accountBalance>
    //                                 <ax25:accountHolderName>Alice</ax25:accountHolderName>
    //                                 <ax25:accountNo>2417254</ax25:accountNo>
    //                                 <ax25:message xsi:nil="true"></ax25:message>
    //                             </ns:return>
    //                         </ns:getAccountDetailsResponse>`;           

    string[] expGetResp = ["Alice","2417254","250000.0"];
    var resp1 = unsecureBankingConnector("urn:getAccountDetails", getReq);
    

    match resp1 {
        soap:SoapResponse soapResponse => {
            xml temp =  <xml>soapResponse.payload;
            //io:println(temp);
            string[] soapGetResp = [<string>temp.selectDescendants(axis:accountHolderName)[0].getTextValue(), 
                                    <string>temp.selectDescendants(axis:accountNo)[0].getTextValue(),
                                    <string>temp.selectDescendants(axis:accountBalance)[0].getTextValue()];
            test:assertEquals(soapGetResp, expGetResp, msg = "Assertion Failed");    
        }
        soap:SoapError soapError => {
            io:println(soapError);  
            test:assertFail(msg = "Failed to retrieve data from the soap end point");
        }
    }

}

@test:Config {
    dependsOn: ["getAccountDetails"]
}
function updateAccountDetails() {
    io:println("Running the test for : Updating account details");
    xml updateReq =   xml `<m0:updateAccountDetails xmlns:m0="http://services.samples">
                                <m0:request>
                                    <m0:accountNo>2417254</m0:accountNo>
                                    <m0:accountBalance>175000.00</m0:accountBalance>
                                </m0:request>
                            </m0:updateAccountDetails>`;

    // xml expUpdateResp = xml `<ns:updateAccountDetailsResponse xmlns:ns="http://services.samples">
    //                             <ns:return xmlns:ax25="http://services.samples/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"xsi:type="ax25:AccountDetails">
    //                                 <ax25:accountBalance>175000.0</ax25:accountBalance>
    //                                 <ax25:accountHolderName>Alice</ax25:accountHolderName>
    //                                 <ax25:accountNo>2417254</ax25:accountNo>
    //                                 <ax25:message xsi:nil="true"></ax25:message>
    //                             </ns:return>
    //                         </ns:updateAccountDetailsResponse>`;

    string[] expUpdateResp = ["Alice","2417254","175000.0"];

    var resp2 = unsecureBankingConnector("urn:updateAccountDetails", updateReq);

    match resp2 {
        soap:SoapResponse soapResponse => {
            xml temp = <xml>soapResponse.payload;
            // io:println(temp);
            string[] soapUpdateResp = [ <string>temp.selectDescendants(axis:accountHolderName)[0].getTextValue(),
                                        <string>temp.selectDescendants(axis:accountNo)[0].getTextValue(),
                                        <string>temp.selectDescendants(axis:accountBalance)[0].getTextValue()];
            test:assertEquals(soapUpdateResp, expUpdateResp, msg = "Assertion Failed");                            
        }
        soap:SoapError soapError => {
            io:println(soapError);
            test:assertFail(msg = "Failed to retrieve data from the soap end point");
        }    
    }

}


@test:Config {
    dependsOn: ["updateAccountDetails"]
}
function deleteAccountDetails() {
    io:println("Running the test for : Removing account details");
    xml deleteReq = xml `<m0:deleteAccountDetails xmlns:m0="http://services.samples">
                            <m0:request>
                                <m0:accountNo>2417254</m0:accountNo>
                            </m0:request>
                        </m0:deleteAccountDetails>`;

    // xml expDeleteResp = xml `<ns:deleteAccountDetailsResponse xmlns:ns="http://services.samples">
    //                             <ns:return xmlns:ax25="http://services.samples/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"xsi:type="ax25:AccountDetails">
    //                                 <ax25:accountBalance>0.0</ax25:accountBalance>
    //                                 <ax25:accountHolderName xsi:nil="true"></ax25:accountHolderName>
    //                                 <ax25:accountNo>0</ax25:accountNo>
    //                                 <ax25:message>Account : 2417254 Deleted Successfully</ax25:message>
    //                             </ns:return>
    //                         </ns:deleteAccountDetailsResponse>`;

    string[] expDeleteResp = ["Account : 2417254 Deleted Successfully"];

    var resp3 = unsecureBankingConnector("urn:deleteAccountDetails", deleteReq);

    match resp3 {
        soap:SoapResponse soapResponse => {
            xml temp = <xml>soapResponse.payload;
            // io:println(temp);
            string[] soapDeleteResp = [ <string>temp.selectDescendants(axis:message)[0].getTextValue()];
            test:assertEquals(soapDeleteResp, expDeleteResp, msg = "Assertion Failed");   
        }
        soap:SoapError soapError => {
            io:println(soapError);
            test:assertFail(msg = "Failed to retrieve data from the soap end point");      
        }    
    }
}

@test:Config {
    dependsOn: ["deleteAccountDetails"]
}
function createAccountDetails() {
    io:println("Running the test for : Creating account details");
    xml createReq = xml `<m0:createAccountDetails xmlns:m0="http://services.samples">
                            <m0:request>
                                <m0:accountNo>2417254</m0:accountNo>
                                <m0:accountHolderName>Alice</m0:accountHolderName>
                                <m0:accountBalance>250000.00</m0:accountBalance>
                            </m0:request>
                        </m0:createAccountDetails>`;

    // xml expCreateResp = xml `<ns:createAccountDetailsResponse xmlns:ns="http://services.samples">
    //                             <ns:return xmlns:ax25="http://services.samples/xsd" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"xsi:type="ax25:AccountDetails">
    //                                 <ax25:accountBalance>250000.0</ax25:accountBalance>
    //                                 <ax25:accountHolderName>Alice</ax25:accountHolderName>
    //                                 <ax25:accountNo>2417254</ax25:accountNo>
    //                                 <ax25:message xsi:nil="true"></ax25:message>
    //                             </ns:return>
    //                         </ns:createAccountDetailsResponse>`;
    
    string[] expCreateResp = ["Alice","2417254","250000.0"];
    var resp5 = unsecureBankingConnector("urn:createAccountDetails", createReq);

    match resp5 {
        soap:SoapResponse soapResponse => {
            xml temp = <xml>soapResponse.payload;
            // io:println(temp);
            string[] soapCreateResp = [ <string>temp.selectDescendants(axis:accountHolderName)[0].getTextValue(),
                                        <string>temp.selectDescendants(axis:accountNo)[0].getTextValue(),
                                        <string>temp.selectDescendants(axis:accountBalance)[0].getTextValue()];
            test:assertEquals(soapCreateResp, expCreateResp, msg = "Assertion Failed");
        }
        soap:SoapError soapError => {
            io:println(soapError);
            test:assertFail(msg = "Failed to retrieve data from the soap end point");
        }
    }

}

@test:Config
function faultAccountDetails() {
    io:println("Running the test for : Faulty account response");
    xml faultReq =   xml `<m0:getAccountDetails xmlns:m0="http://services.samples">
                            <m0:request>
                                <m0:accountNo>2417258</m0:accountNo>
                            </m0:request>
                        </m0:getAccountDetails>`;

    // xml expFaultResp =    xml   `<soapenv:Fault xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    //                                 <faultcode>soapenv:Server</faultcode>
    //                                 <faultstring>Account Not Found in the Database</faultstring>
    //                                 <detail>
    //                                     <ns:UnsecureBankingServiceException xmlns:ns="http://services.samples">
    //                                         <ns:UnsecureBankingServiceException>
    //                                             <axis2ns1:Message xmlns:axis2ns1="http://services.samples">Account Not Found in the Database</axis2ns1:Message>
    //                                         </ns:UnsecureBankingServiceException>
    //                                     </ns:UnsecureBankingServiceException>
    //                                 </detail>
    //                             </soapenv:Fault>`;            

    string[] expFaultResp = ["Account Not Found in the Database"];
    var resp4 = unsecureBankingConnector("urn:getAccountDetails", faultReq);
    
    match resp4 {
        soap:SoapResponse soapResponse => {
            xml temp = <xml>soapResponse.payload;
            // io:println(temp);
            string[] soapFaultResp = [ <string>temp.selectDescendants(ns:Message)[0].getTextValue()];
            test:assertEquals(soapFaultResp, expFaultResp, msg = "Failed");
            
        }
        soap:SoapError soapError => {
            io:println(soapError);  
            test:assertFail(msg = "Failed to retrieve data from the soap end point");
        }
    }
}    


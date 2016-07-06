var xmlHttp = createXmlHttpRequestObject();
console.log(xmlHttp);


function createXmlHttpRequestObject()
{
        var xmlHttp;

        if(window.ActiveXObject)
        {
                try{
                        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
                }catch(e){
                        xmlHttp = false;
                }
        }else
        {
                try{
                        xmlHttp = new XMLHttpRequest();
                }catch(e){
                        xmlHttp = false;
                }

        }

        if(!xmlHttp)
                console.log("failed to get http xml request");
        else
                return xmlHttp;

}

function process()
{

        console.log("process started");
        if(xmlHttp.readyState == 0 || xmlHttp.readyState == 4)
        {

                console.log("inputField contains " +document.getElementById("user_input").value);
                serial = encodeURIComponent(document.getElementById("user_input").value);
                xmlHttp.open("GET", "get_serial.cgi?serial="+serial, true);
                xmlHttp.onreadystatechange = handleServerResponse;
                xmlHttp.send(null);
        }else
        {
                console.log("timeout");
                xmlHttp.timeout = 1000;
        }

}

function handleServerResponse()
{
        if(xmlHttp.readyState == 0 || xmlHttp.readyState == 4)
        {
                if(xmlHttp.status == 200)
                {
                        console.log("communication with server - 200 response");
                        console.log(xmlHttp.responseURL);
                        console.log(xmlHttp.responseText);
                        //xmlHttp.XMLHttpRequest;
                        document.getElementById("results").innerHTML = xmlHttp.responseText;
                }
        }else
        {

                //console.log("something went wrong");
        }
}

<%@ taglib prefix="cs" uri="futuretense_cs/ftcs1_0.tld" %>
<%@ taglib prefix="ics" uri="futuretense_cs/ics.tld" %>
<%@ taglib prefix="satellite" uri="futuretense_cs/satellite.tld" %>

<%@ page import="COM.FutureTense.Interfaces.FTValList" %>
<%@ page import="COM.FutureTense.Interfaces.ICS" %>
<%@ page import="COM.FutureTense.Interfaces.IList" %>
<%@ page import="COM.FutureTense.Interfaces.Utilities" %>
<%@ page import="COM.FutureTense.Util.ftErrors" %>
<%@ page import="COM.FutureTense.Util.ftMessage"%>

<cs:ftcs>

<script language="JavaScript">

var debug       = false;
var req_fields  = new Array();

req_fields["CSusername"]    = "Please enter the username";
req_fields["CSpassword"]    = "Plese enter the password";
req_fields["LDAPusername"]  = "Please enter the username";
req_fields["LDAPpassword"]  = "Plese enter the password";
req_fields["IniDir"]        = "Please enter the ini directory";
req_fields["DirServer"]     = "Please select a directory server";


function Debug (msg) {

    if (debug) {
        alert ("DEBUG: " + msg);
    }
}

function ValidateFields (form, fieldToCheck) {
    Debug ("Entered ValidateFields()");

    for (var i=0; i<form.elements.length; i++) {
        var obj = form.elements[i];
        var name = obj.name;
        var type = obj.type;
        var value = obj.value;
        Debug ("NAME=[" + name + "]\nTYPE=[" + type + "]\nVALUE=[" + value + "]");

        // Check whether this field needs to be checked
        var checkThisField = false;
        for (var j=0; j<fieldToCheck.length; j++) {
            Debug ("FIELD[" + fieldToCheck[j] + "]==[" + name + "]");
            if (fieldToCheck[j] == name) {
                checkThisField = true;
                break;
            }
        }
        Debug ("Check " + name + "? " + checkThisField);
        if (! checkThisField) {
            continue;
        }

        Debug ("Value of : " + name + " = " + value);
        if ((value != undefined) && (value == "")) {
            var error = "Please fill in " + obj.name;
            if (req_fields[name] != undefined) {
                error = req_fields[obj.name];
            }
            alert (error);
            return false;
        }

    }

    return true;
}

// If the anymous access is not allowed you should provide username
function ValidateAnymousAccess(form) {
    var status = true;

    var anonymousaccess = form.AnonymousAccess.checked;
    var username = form.LDAPusername.value;
    var password = form.LDAPpassword.value;

    if (! anonymousaccess) {
        if ((username == undefined) || (username == "")) {
            status = false;
            alert ("Username field can't be blank when anonymous access is not allowed.");
        }
    } else {
        // alert ("username : '" + username + "'");
        if ((username == undefined) || (username != "")) {
            status = false;
            alert ("Username should be blank when anonymous access is checked");
        } else if ((password == undefined) || (password != "")) {
            status = false;
            alert ("Password should be blank when anonymous access is checked");
        }
    }

    return status;
}

function ValidateCSLoginScreen (form) {
    var checkFields = new Array("CSusername", "CSpassword");
    return ValidateFields(form, checkFields);
}

function ValidateLDAPScreen (form) {
    var status = true;

    status = ValidateAnymousAccess(form);

    if (status) {
        var checkFields = new Array("IniDir");
        status = ValidateFields(form, checkFields);
    }

    return status;
}

function ValidateRollbackScreen (form) {
    var checkFields = new Array("IniDir");
    return ValidateFields(form, checkFields);
}

</script>

</cs:ftcs>

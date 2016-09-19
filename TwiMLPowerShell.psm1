function New-TwiMLRedirect {
    param (
        [ValidateSet("GET","POST")]$Method,
        $URL
    )
    New-XMLElement -Name Redirect -Attributes @{method=$Method} -InnerText $URL
}

Function New-TwiMLGather {
    param (
        $Action,
        [ValidateSet("GET","POST")]$Method,
        [ValidateScript({$_ -gt 0})][Int]$Timeout,
        [ValidateSet(0,1,2,3,4,5,6,7,8,9,"#","*","")]$FinishOnKey,
        [ValidateScript({$_ -ge 1})][Int]$numDigits,
        $InnerElements
    )
    $ParametersToTurnIntoAttributes = $PSBoundParameters
    $ParametersToTurnIntoAttributes.Remove("InnerElements") | Out-Null

    New-XMLElement -Name Gather -Attributes $ParametersToTurnIntoAttributes -InnerElements $InnerElements
}

#https://www.twilio.com/docs/api/twiml/say
Function New-TwiMLSay {
    param (
        [ValidateSet("man", "woman", "alice")]$Voice,
        [ValidateScript({$_ -ge 1})][Int]$Loop,
        $Language,
        [Parameter(Mandatory)]$Message
    )
    $ParametersToTurnIntoAttributes = $PSBoundParameters
    $ParametersToTurnIntoAttributes.Remove("Message") | Out-Null

    New-XMLElement -Name Say -Attributes $ParametersToTurnIntoAttributes -InnerText $Message
}

Function New-TwiMLResponse {
    Param (
        $InnerElements
    )
    New-XMLElement -Name Response -InnerElements $InnerElements
}

Function New-TwiMLXMLDocument {
    Param (
        $InnerElements
    )
    New-XMLDocument -Version "1.0" -Encoding "UTF-8" -InnerElements $InnerElements
}

Function New-TwiMLHangup {
    New-XMLElement -Name Hangup
}
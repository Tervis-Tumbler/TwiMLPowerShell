#Requires -modules WebServicesPowerShellProxyBuilder

#https://www.twilio.com/docs/api/twiml
function New-TwiMLRedirect {
    param (
        [ValidateSet("GET","POST")]$Method,
        $URL,
        [Switch]$AsString
    )

    New-XMLElement -Name Redirect -Attributes @{method=$Method} -InnerText $URL -AsString:$AsString
}

Function New-TwiMLGather {
    param (
        $Action,
        [ValidateSet("GET","POST")]$Method,
        [ValidateScript({$_ -gt 0})][Int]$Timeout,
        [ValidateSet(0,1,2,3,4,5,6,7,8,9,"#","*","")]$FinishOnKey,
        [ValidateScript({$_ -ge 1})][Int]$numDigits,
        $InnerElements,
        [Switch]$AsString
    )

    New-TwiMLXMLElement -Name Gather -Parameters $PSBoundParameters -ExcludeProperty InnerElements,AsString -InnerElements $InnerElements
}

Function New-TwiMLSay {
    param (
        [ValidateSet("man", "woman", "alice")]$Voice,
        [ValidateScript({$_ -ge 1})][Int]$Loop,
        $Language,
        [Parameter(Mandatory)]$Message,
        [Switch]$AsString
    )

    New-TwiMLXMLElement -Name Say -Parameters $PSBoundParameters -ExcludeProperty Message,AsString -InnerText $Message
}

Function New-TwiMLResponse {
    Param (
        $InnerElements,
        [Switch]$AsString
    )
    New-XMLElement -Name Response -InnerElements $InnerElements -AsString:$AsString
}

Function New-TwiMLXMLDocument {
    Param (
        $InnerElements,
        [Switch]$AsString
    )
    New-XMLDocument -Version "1.0" -Encoding "UTF-8" -InnerElements $InnerElements -AsString:$AsString
}

Function New-TwiMLHangup {
    param (
        [Switch]$AsString
    )

    New-XMLElement -Name Hangup -AsString:$AsString
}

Function New-TwiMLRecord {
    param (
        $action,
        [ValidateSet("GET","POST")]$method,
        [ValidateScript({$_ -gt 0})][Int]$Timeout,
        [ValidateSet(0,1,2,3,4,5,6,7,8,9,"#","*","")]$FinishOnKey,
        [ValidateScript({$_ -ge 1})]$maxLength,
        [Bool]$Transcribe,
        $TranscribeCallback,
        [Bool]$PlayBeep,
        [ValidateSet("trim-silence","do-not-trim")]$Trim,
        [Switch]$AsString
    )

    New-TwiMLXMLElement -Name Record -Parameters $PSBoundParameters -ExcludeProperty InnerElements,AsString
}

Function New-TwiMLXMLElement {
    [cmdletbinding(DefaultParameterSetName='InnerElements')]
    param (
        $Name,
        $Parameters,
        $ExcludeProperty,
        [Parameter(ParameterSetName="InnerElements")]$InnerElements,
        [Parameter(ParameterSetName="InnerText")]$InnerText
    )
    
    $Attributes = $Parameters | 
    ConvertFrom-PSBoundParameters -ExcludeProperty $ExcludeProperty -AsHashTable

    if ($InnerElements) {
        New-XMLElement -Name $Name -Attributes $Attributes -InnerElements $InnerElements -AsString:$Parameters["AsString"]
    } elseif ($InnerText) {
        New-XMLElement -Name $Name -Attributes $Attributes -InnerText $InnerText -AsString:$Parameters["AsString"]
    } else {
        New-XMLElement -Name $Name -Attributes $Attributes -AsString:$Parameters["AsString"]
    }
}
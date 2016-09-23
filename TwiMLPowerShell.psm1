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

    $Attributes = $PSBoundParameters | 
    ConvertFrom-PSBoundParameters |
    select -Property * -ExcludeProperty InnerElements,AsString

    New-XMLElement -Name Gather -Attributes $Attributes -InnerElements $InnerElements -AsString:$AsString
}

Function New-TwiMLSay {
    param (
        [ValidateSet("man", "woman", "alice")]$Voice,
        [ValidateScript({$_ -ge 1})][Int]$Loop,
        $Language,
        [Parameter(Mandatory)]$Message,
        [Switch]$AsString
    )
    $Attributes = $PSBoundParameters | 
    ConvertFrom-PSBoundParameters |
    select -Property * -ExcludeProperty Message,AsString

    New-XMLElement -Name Say -Attributes $Attributes -InnerText $Message -AsString:$AsString
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
    $Attributes = $PSBoundParameters | 
    ConvertFrom-PSBoundParameters |
    select -Property * -ExcludeProperty InnerElements,AsString

    New-XMLElement -Name Record -Attributes $Attributes -InnerElements $InnerElements -AsString:$AsString
}

Function New-TwiMLXMLElement {
    param (
        $Parameters
    )
    New-XMLElement -Name Record -Attributes $Attributes -InnerElements $InnerElements -AsString:$AsString

}
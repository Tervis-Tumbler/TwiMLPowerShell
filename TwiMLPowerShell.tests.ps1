Import-Module -Force TwiMLPowerShell

Describe "New-TwiMLRecord" {
    It "Creates basic Record element" {
        New-TwiMLRecord -action "https://www.google.com" -method GET -Timeout 3 -FinishOnKey * -maxLength 3 -Transcribe $True -TranscribeCallback "http://my.server.com/callback" -PlayBeep $True -Trim trim-silence -AsString |
        Should be '<Record action="https://www.google.com" method="GET" Timeout="3" FinishOnKey="*" maxLength="3" Transcribe="True" TranscribeCallback="http://my.server.com/callback" PlayBeep="True" Trim="trim-silence" />'
    }
}

Describe "New-TwiMLGather" {
    It "Creates basic TwiMLGather element" {
        New-TwiMLGather -Action "https://www.google.com" -Method POST -Timeout 10 -FinishOnKey `# -numDigits 20 -AsString |
        Should be '<Gather Action="https://www.google.com" Method="POST" Timeout="10" FinishOnKey="#" numDigits="20" />'
    }
    It "Creates basic TwiMLGather element with a inner Say element" {
        New-TwiMLGather -Action "https://www.google.com" -Method POST -Timeout 10 -FinishOnKey `# -numDigits 2 -AsString -InnerElements (
            (New-TwiMLSay -Voice alice -Message "Press 11 for Sales"),
            (New-TwiMLSay -Voice alice -Message "Press 12 for Marketing")
        ) |
        Should be '<Gather Action="https://www.google.com" Method="POST" Timeout="10" FinishOnKey="#" numDigits="2"><Say Voice="alice">Press 11 for Sales</Say><Say Voice="alice">Press 12 for Marketing</Say></Gather>'
    }
}

Describe "Integration Test" {
    It "Build out complext menu" {
        New-TwiMLXMLDocument -AsString -InnerElements (
            New-TwiMLResponse -InnerElements (
                New-TwiMLGather -Action "https://www.google.com" -Method POST -Timeout 10 -FinishOnKey `# -numDigits 20 -InnerElements (
                    (New-TwiMLSay -Voice alice -Message "Press 11 for Sales"),
                    (New-TwiMLSay -Message "Press 12 for Marketing")
                )  
            )
        ) |
        Should Be '<?xml version="1.0" encoding="UTF-8"?><Response><Gather Action="https://www.google.com" Method="POST" Timeout="10" FinishOnKey="#" numDigits="20"><Say Voice="alice">Press 11 for Sales</Say><Say Voice="alice">Press 12 for Marketing</Say></Gather></Response>'
    }
}
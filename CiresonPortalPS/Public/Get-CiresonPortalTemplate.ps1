function Get-CiresonPortalTemplate
{
<#
.SYNOPSIS
    Function to retrieve all the Template
.DESCRIPTION
    Function to retrieve all the Template
.PARAMETER ClassID
    Specifies the management pack class Id
.PARAMETER Type
    Specifies the type of item to return (instead of specifying the classid)
    'ServiceRequest','IncidentRequest','Activity','ChangeRequest'
.EXAMPLE
    Get-CiresonPortalTemplate -classid "04b69835-6343-4de2-4b19-6be08c612989"

    Returns all the Service Request Template
.EXAMPLE
    Get-CiresonPortalTemplate -Type "ServiceRequest"

    Returns all the Service Request Template
.NOTES
    Francois-Xavier Cat
    lazywinadmin.com
    @lazywinadm
    github.com/lazywinadmin
.LINK
    https://support.cireson.com/Help/Api/GET-api-V3-Template-GetTemplates_classId
#>
    [Cmdletbinding(DefaultParameterSetName="All")]
    PARAM(
        [parameter(Mandatory,ParameterSetName="ClassID")]
        [Guid]$ClassID,

        [parameter(Mandatory,ParameterSetName="Type")]
        [ValidateSet('ServiceRequest','IncidentRequest','Activity','ChangeRequest')]
        $Type
    )

    BEGIN
	{
		TRY{
			Write-Verbose -Message $(New-ScriptMessage -Block BEGIN -message 'Checking Pre-Requisites')
			[void](Get-CiresonPortalPSConfiguration -WarningAction Stop)
		}
		CATCH
		{
			# Stop the function
			Throw "Not Connected to Cireson Portal"
		}
	}
    PROCESS
    {
        IF($PSCmdlet.ParameterSetName -eq 'ClassID')
        {
            # Build the Query
            $URI = $CiresonPortalURL, "api/V3/Template/GetTemplates?classId=$ClassID" -join '/'
            Write-Verbose -Message $(New-ScriptMessage -Block PROCESS -message $URI)
        }
        ELSEIF($PSCmdlet.ParameterSetName -eq 'Type')
        {
            Switch ($Type)
            {
                'ServiceRequest' { $Class = "04b69835-6343-4de2-4b19-6be08c612989"}
                'IncidentRequest' {$Class = "a604b942-4c7b-2fb2-28dc-61dc6f465c68"}
                'Activity' {$Class = "42642d4f-d342-3f1b-965c-628a0f4119e2"}
                'ChangeRequest' {$Class = "e6c9cf6e-d7fe-1b5d-216c-c3f5d2c7670c"}
            }
            # Build the Query
            $URI = $CiresonPortalURL, "api/V3/Template/GetTemplates?classId=$Class" -join '/'
            Write-Verbose -Message $(New-ScriptMessage -Block PROCESS -message $URI)
        }

        # Invoke the Query
	    (Invoke-RestMethod $URI -Credential $CiresonPortalCred) -as [PSCustomObject]

    }
}

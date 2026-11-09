# ============================================================
# PORTFOLIO DEMONSTRATION - SYNTHETIC TEST DATA ONLY
# NO PRODUCTION, EMPLOYER, OR PERSONAL DATA IS INCLUDED
# ============================================================

<#
.SYNOPSIS
    Creates a sample Microsoft Entra ID identity governance report.

.DESCRIPTION
    Demonstrates how PowerShell can evaluate identity governance
    indicators including account status, MFA registration,
    privileged access, PIM eligibility, and review requirements.

    This script uses synthetic test identities only.

.NOTES
    Purpose: GitHub portfolio demonstration
    Data: Synthetic test identities only
#>

$Users = @(
    [PSCustomObject]@{
        DisplayName       = "TEST USER 001"
        UserPrincipalName = "test.user001@example.com"
        AccountStatus     = "Enabled"
        MFAStatus         = "Registered"
        PrivilegedRole    = "None"
        PIMEligible       = $false
    }

    [PSCustomObject]@{
        DisplayName       = "TEST PRIVILEGED ADMIN 001"
        UserPrincipalName = "test.admin001@example.com"
        AccountStatus     = "Enabled"
        MFAStatus         = "Registered"
        PrivilegedRole    = "Global Reader"
        PIMEligible       = $true
    }

    [PSCustomObject]@{
        DisplayName       = "TEST DISABLED USER 001"
        UserPrincipalName = "test.disabled001@example.com"
        AccountStatus     = "Disabled"
        MFAStatus         = "N/A"
        PrivilegedRole    = "None"
        PIMEligible       = $false
    }

    [PSCustomObject]@{
        DisplayName       = "TEST USER 002"
        UserPrincipalName = "test.user002@example.com"
        AccountStatus     = "Enabled"
        MFAStatus         = "Not Registered"
        PrivilegedRole    = "None"
        PIMEligible       = $false
    }
)

$GovernanceReport = foreach ($User in $Users) {

    $ReviewResult = "OK"

    if ($User.AccountStatus -eq "Disabled") {
        $ReviewResult = "Lifecycle Review"
    }
    elseif ($User.MFAStatus -eq "Not Registered") {
        $ReviewResult = "MFA Review"
    }
    elseif ($User.PrivilegedRole -ne "None") {
        $ReviewResult = "Privileged Access Review"
    }

    [PSCustomObject]@{
        DisplayName       = $User.DisplayName
        UserPrincipalName = $User.UserPrincipalName
        AccountStatus     = $User.AccountStatus
        MFAStatus         = $User.MFAStatus
        PrivilegedRole    = $User.PrivilegedRole
        PIMEligible       = $User.PIMEligible
        ReviewResult      = $ReviewResult
    }
}

$GovernanceReport | Format-Table -AutoSize

$GovernanceReport |
    Export-Csv ".\Sample-Governance-Report.csv" -NoTypeInformation

Write-Host ""
Write-Host "TEST DATA ONLY - No production identities were processed."
Write-Host "Sample governance report created successfully."

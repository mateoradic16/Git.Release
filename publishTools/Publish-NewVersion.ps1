param ($version, $assetFiles, $releaseModule)
Import-Module -Name $releaseModule -Scope Local

# Specify the parameters required to create the release. Do it as a hash table for easier readability.
$array = Get-ChildItem -Path $assetFiles -Recurse | Select-Object -ExpandProperty FullName
Write-Output "Uploading Release to GitHub... v$($version)"
Write-Output "Files:"
Write-Output $array
$newGitHubReleaseParameters =
@{
    GitHubUsername = 'mateoradic16'
    GitHubRepositoryName = 'ForexTradingUI'
    GitHubAccessToken = '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'
    ReleaseName = "ForexTradingUI.Release.v$($version)"
    TagName = "v$($version)"
    ReleaseNotes = "This is an automatic Release triggered by Release build!"
    AssetFilePaths = @($array)
    IsPreRelease = $false
    IsDraft = $false	# Set to true when testing so we don't publish a real release (visible to everyone) by accident.
}

# Try to create the Release on GitHub and save the results.
$result = New-GitHubRelease @newGitHubReleaseParameters

# Provide some feedback to the user based on the results.
if ($result.Succeeded -eq $true)
{
    Write-Output "Release published successfully! View it at $($result.ReleaseUrl)"
}
elseif ($result.ReleaseCreationSucceeded -eq $false)
{
    Write-Error "The release was not created. Error message is: $($result.ErrorMessage)"
}
elseif ($result.AllAssetUploadsSucceeded -eq $false)
{
    Write-Error "The release was created, but not all of the assets were uploaded to it. View it at $($result.ReleaseUrl). Error message is: $($result.ErrorMessage)"
}
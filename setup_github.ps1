\
Param(
  [Parameter(Mandatory=$true)]
  [string]$GitHubUser,
  [string]$RepoName = "ppao-site"
)

function Check-Command($cmd) {
  if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
    Write-Error "Missing dependency: $cmd"
    exit 1
  }
}

Check-Command git
Check-Command gh

# Login if needed
try {
  gh auth status | Out-Null
} catch {
  gh auth login
}

# Create repo and push
gh repo create "$GitHubUser/$RepoName" --public --source=. --remote=origin --push

git branch -M main
git push -u origin main

Write-Host "Once the workflow finishes, your site will be available at:"
Write-Host "  https://$GitHubUser.github.io/"
Write-Host "  https://$GitHubUser.github.io/pages/"
Write-Host "  https://$GitHubUser.github.io/pages/hr/khrxngkar-thdsxb/"

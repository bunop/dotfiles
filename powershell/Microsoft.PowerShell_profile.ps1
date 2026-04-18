# Microsoft.PowerShell_profile.ps1
Set-Alias ll Get-ChildItem

# Configure PSReadLine for enhanced command history management and predictive suggestions.
Set-PSReadLineOption `
    -MaximumHistoryCount 20000 `
    -HistoryNoDuplicates `
    -HistorySearchCursorMovesToEnd `
    -HistorySaveStyle SaveIncrementally

# use arrow keys to search history based on the current input
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Enable predictive suggestions from command history.
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Avoid saving commands with possible secrets or frequent noise in history.
Set-PSReadLineOption -AddToHistoryHandler {
    param($line)

    if ($line -match '(?i)password|token|apikey|secret') {
        return $false
    }

    if ($line -match '^(cd|ls|ll|pwd|cls|exit)$') {
        return $false
    }

    return $true
}

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Load .NET assembly
Add-Type -AssemblyName System.Data.SqlClient

# Retrieve the connection string from the function app settings.
$connectionString = "Server=tcp:<server>,1433;Initial Catalog=<database>;Persist Security Info=False;User ID=<username>;Password=<password>;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"

# Retrieve QueryID from query parameters or request body
$QueryID = $Request.Query.QueryID
if (-not $QueryID) {
    $QueryID = $Request.Body.QueryID
}

# Define SQL query using parameterized query to avoid SQL injection
$query = "SELECT UserName FROM Users WHERE UserID = @QueryID"

# Create and open a connection
$connection = New-Object System.Data.SqlClient.SqlConnection($connectionString)
$command = $connection.CreateCommand()
$command.CommandText = $query

# Add the QueryID parameter to avoid SQL injection
$param = $command.CreateParameter()
$param.ParameterName = "@QueryID"
$param.Value = $QueryID
$command.Parameters.Add($param)

# Execute the command
try {
    $connection.Open()
    $reader = $command.ExecuteReader()

    # Initialize a variable to hold the response
    $response = $null

    if ($reader.HasRows) {
        while ($reader.Read()) {
            $response = $reader["UserName"]
        }
    } else {
        $response = "No user found with ID $QueryID."
    }
}
catch {
    $response = "Error: $_"
}
finally {
    $connection.Close()
}

# Return response
if ($response -eq $null) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [System.Net.HttpStatusCode]::NotFound
        Body = "No user found with ID $QueryID."
    })
} else {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [System.Net.HttpStatusCode]::OK
        Body = "The user name for ID $QueryID is: $response"
    })
}

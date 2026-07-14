![Architecture](images/Microservice.png)

# Dashboard API Gateway

## Introduction

✍️ The Go Engine injects the data and Python controls the AI retrieval loops, the .NET9 API functions as the operational cockpit of CloudShield-AI. It exposes the REST endpoints  that the admin frontend can use to audit recent agent findings, fetch security event metrics, and execute human-in-the-loop approvals

## Prerequisite

✍️ We are using .NET 9 for this, so you need to have dotnet installed.


## Cloud Research

- ✍️ Dotnet documentation

## Try yourself


### Step 1 — Scaffold an Empty web project
```
dotnet new web -o cloudshield-gateway

# Enter the project directory
cd cloudshield-gateway
```

### Step 2 — Pull in the package fo rthe PostgresSQL dependency
```
dotnet add package Npgsql
```

### Step 3 — Add the ConnectionString to the appsettings.json
```
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*",
  "ConnectionStrings": {
    "PostgresDB":"Host=172.17.0.2;Port=5432;Database=cloudshield;Username=******;Password=***************"
  }
}
```

### Step 4 — Edit the Program.cs
```
using Npgsql;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("PostgresDB");
var app = builder.Build();

app.MapGet("/", () => "CloudShield-AI Master Control Plane API");

app.MapGet("/api/dashboard/actions/pending", async () =>
{
    var pendingActions =new List<object>();
    await using var conn=new NpgsqlConnection(connectionString);
    await conn.OpenAsync();

    var sql="SELECT id, document_id, action_type, description, status FROM agent_actions WHERE status='PENDING';";
    await using var cmd=new NpgsqlCommand(sql, conn);
    await using var reader=await cmd.ExecuteReaderAsync();

    while(await reader.ReadAsync())
    {
        pendingActions.Add(new
        {
            Id=reader.GetGuid(0),
            DocumentId = reader.GetGuid(1),
            ActionType = reader.GetString(2),
            Description = reader.GetString(3),
            Status=reader.GetString(4)
        });
    }
    return Results.Ok(pendingActions);
});

app.MapPost("/api/dashboard/actions/{id}/approve",async (Guid id)=>
{
    await using var conn = new NpgsqlConnection(connectionString);
    await conn.OpenAsync();

    var sql = "UPDATE agent_actions SET status = 'APPROVED' WHERE id = @id;";
    await using var cmd = new NpgsqlCommand(sql, conn);
    cmd.Parameters.AddWithValue("id",id);

    int rowsAffected = await cmd.ExecuteNonQueryAsync();

    if (rowsAffected == 0)
    {
        return Results.NotFound(new { Message = $"Action ID {id} not found."});
    }
    Console.WriteLine($"Admin Callback: Security Patch Action {id} state changed to APPROVED.");
    return Results.Ok(new {Message = $"Action {id} authorized. Deploying compliance patch to target cloud group."});
});

app.Run();

```


## ☁️ Cloud Outcome

✍️ This is the first time building an api with C#. I found C# very easy to read and understand. It looked alot like javascript. 

## Next Steps

✍️ Since we hava a polyglot application this would be a perfect use case for implementing grpc.

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[link](link)

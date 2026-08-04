```mermaid
graph TD
    %% Styling
    classDef client fill:#334155,stroke:#475569,stroke-width:2px,color:#fff;
    classDef gateway fill:#1e293b,stroke:#3b82f6,stroke-width:2px,color:#fff;
    classDef compute fill:#0f172a,stroke:#10b981,stroke-width:2px,color:#fff;
    classDef storage fill:#0f172a,stroke:#f59e0b,stroke-width:2px,color:#fff;
    classDef iam fill:#0f172a,stroke:#8b5cf6,stroke-width:2px,color:#fff;
    classDef boundary fill:#f8fafc,stroke:#94a3b8,stroke-width:2px,stroke-dasharray: 5 5,color:#0f172a;

    subgraph External_Client[" External Client Layer "]
        Client["HTTP POST Client<br/>(curl / API Consumer)"]:::client
    end

    subgraph Azure_Resource_Group[" Azure Resource Group: rg-acl-pattern-dev (East US 2) "]
        class Azure_Resource_Group boundary;

        subgraph Security_Identity[" Entra ID Security Boundary "]
            MSI["System-Assigned<br/>Managed Identity"]:::iam
        end

        subgraph Serverless_Compute[" Serverless Compute Layer "]
            ASP["Flex Consumption Plan<br/>(FC1 Linux Tier)"]:::compute
            FuncApp["Azure Function App<br/>(func-acl-dev-*)<br/>• .NET 8 Isolated Worker<br/>• HTTPS-Only / TLS 1.2+"]:::compute
            
            subgraph ACL_Engine[" Anti-Corruption Layer (In-Memory Processing) "]
                ModelIn["1. ModernUserRequest<br/>(Raw Payload)"]
                Trans["2. UserAclTranslator<br/>(Domain Adapter)"]
                ModelOut["3. LegacyDomainUser<br/>(Standardized Output)"]
            end
        end

        subgraph Storage_Tier[" Storage Security Boundary "]
            Storage["Azure Storage Account<br/>(stacldev*)<br/>• TLS 1.2+ Enforced<br/>• Public Blob Access: Disabled"]:::storage
            Container["Blob Container<br/>(app-package-*)"]:::storage
        end
    end

    %% Relationships & Flow
    Client -- "1. Enforce HTTPS POST /api/user" --> FuncApp
    FuncApp -. "Owns Lifecycle" .-> MSI
    MSI -- "2. Keyless Auth: Storage Blob Data Owner<br/>(b7e6dc6d-f1e8-4753-8033-0f276bb0955b)" --> Storage
    FuncApp -- "3. Deploy & Host Package" --> Container
    ASP -. "Executes & Scales" .-> FuncApp

    ModelIn --> Trans --> ModelOut

    %% Layout Links
    Storage --- Container
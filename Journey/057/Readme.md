![Architecture](images/Cloud%20Shield%20AI.png)

# CloudShield AI

## Introduction

✍️ CloudShieldAI is a multi-agent security audit and compliance that ingests raw company
documentation, real-time AWS CloudTrail logs, and codebases to automatically detect 
vulnerabilities, explain compliance gaps, and safely execute remediation steps.

## Prerequisite

✍️ In this step we are setting up the database schema. The Postgres database is running in a docker container, so docker should be installed. We are using pgAdmin to interact with the database, so that needs to be installed also.

## Use Case

- I am implementing a hybrid database strategy. A C# API will store user profiles, agent execution logs, and permission scopes in standard relational tables. Within the same database pgvector will store the document embedding vectors.


### Step 1 — Run the postgres container
```
docker run --name cloudshield-db \
> -e POSTGRES_DB=cloudshield \
> -e POSTGRES_USER=postgres \
> -e POSTGRES_PASSWORD=<password> \
> -p 5423:5432 \
> -d ankane/pgvector:latest
```


### Step 2 — Create database in pgadmin
```
name = cloudshield local
user=postgres
password=<password>
host-<find this with docker inspect, docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cloudshield-db>
```
![Screenshot](https://via.placeholder.com/500x300)

### Step 4  — create schema in query editor
```
CREATE EXTENSION IF NOT EXISTS vector;

-- =========================================================================
-- RELATIONAL LAYER (Managed primarily by C# Backend)
-- =========================================================================

-- Tracks corporate documents uploaded to the system
CREATE TABLE documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    filename VARCHAR(255) NOT NULL,
    s3_uri VARCHAR(512) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    uploaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    processed_status VARCHAR(50) DEFAULT 'PENDING' -- PENDING, PROCESSED, FAILED
);

-- Tracks active AI Agent auditing sessions
CREATE TABLE audit_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) DEFAULT 'ACTIVE' -- ACTIVE, COMPLETED, FAILED
);

-- Tracks explicit tool executions and actions taken by the agents
-- Crucial for security auditing and Human-in-the-loop approvals!
CREATE TABLE agent_actions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID REFERENCES audit_sessions(id) ON DELETE CASCADE,
    agent_name VARCHAR(100) NOT NULL, -- e.g., 'AuditorAgent', 'RemediationAgent'
    proposed_action TEXT NOT NULL,     -- e.g., 'Modify Security Group sg-123 to close port 22'
    action_type VARCHAR(50) NOT NULL,  -- READ, WRITE_PROPOSAL
    approval_status VARCHAR(50) DEFAULT 'PENDING_APPROVAL', -- APPROVED, REJECTED, PENDING_APPROVAL
    reviewed_by VARCHAR(100),
    executed_at TIMESTAMPTZ
);

-- =========================================================================
-- VECTOR / KNOWLEDGE LAYER (Populated by Go, Searched by Python)
-- =========================================================================

-- Stores the tokenized chunks of your security documents and their embeddings
CREATE TABLE document_chunks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES documents(id) ON DELETE CASCADE,
    chunk_index INT NOT NULL,
    page_number INT,
    content TEXT NOT NULL, -- The actual raw text segment
   
    -- 1536 dimensions is the standard output size for models like Amazon Titan Text Embeddings
    -- and OpenAI text-embedding-3-small. Swap to 1024 if using Cohere English.
    embedding vector(1536)
);

-- =========================================================================
-- PERFORMANCE TUNING (The HNSW Index)
-- =========================================================================

-- Create a Hierarchical Navigable Small World (HNSW) index for rapid semantic search.
-- Cosine distance (vector_cosine_ops) is the industry standard for text alignment.
CREATE INDEX ON document_chunks USING hnsw (embedding vector_cosine_ops);

```

## ☁️ Cloud Outcome

✍️ I did not know I can have a vector database in postgres. Also I never connected a database running in docker to pgadmin

## Next Steps

✍️ The next step is to build the Go ingestion service

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[linkedIn](https://www.linkedin.com/pulse/day-57100-days-cloud-cloudshield-ai-demian-jennings-inkle)

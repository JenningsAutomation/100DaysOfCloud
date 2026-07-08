![Python Retrieval](images/CloudShield-AI%20Ingestion_Retrieval_Pipeline.png)

# Python Retrieval Layer

## Introduction

✍️ Following yesterday’s work on the Go-based ingestion pipeline, today I focused on building the retrieval side of the "CloudShield-AI" project using Python and LangChain. 

## Prerequisite

✍️ Create a python virtual environment and pip install the dependencies is my requirements.txt.

## Use Case

- While Go handles the high-throughput parsing and database streaming, Python serves as the application's reasoning layer, managing how security queries locate relevant context.

## Cloud Research

Here is a quick look at the technical mechanics established today:
- LangChain Embeddings: Implemented LangChain’s Bedrock module to process natural language queries through Amazon Titan Text Embeddings V2 (us-east-1). This converts human text into 1024-dimensional query vectors.

- Vector Distance Search: Utilized the native psycopg2 driver to run Cosine Distance searches (<=>) against our PostgreSQL Docker container. This allows the system to cross-reference incoming questions with the document chunks stored by the Go service, taking full advantage of the accelerated HNSW database index.

The local architecture forms a complete RAG (Retrieval-Augmented Generation) loop: Go writes the embeddings into storage, and Python handles the targeted vector retrieval.

## Next Steps

✍️ Moving into Sprint 3 to build out the C# (.NET 9) dashboard control plane to add a human-in-the-loop review interface.

## Social Proof

✍️ Show that you shared your process on Twitter or LinkedIn

[linkedin](https://www.linkedin.com/posts/demian-jennings_cloudcomputing-aiengineering-python-share-7480473657866186752-zedF/?utm_source=share&utm_medium=member_desktop&rcm=ACoAADXbhxEBzxsfNpRcEjDWcxJMI75kD_O-eRA)

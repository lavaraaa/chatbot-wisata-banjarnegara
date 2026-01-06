# be-express-wisata-banjarnegara

Express.js rewrite of the wisata Banjarnegara recommendation backend.

## Prerequisites

- Node.js 18+
- pnpm / npm / yarn (examples use pnpm)
- [Chroma Cloud](https://docs.trychroma.com/deployment/chroma-cloud) account with API key
- Google Gemini API key (for LLM and embeddings)
- TomTom API key (for distance calculations)

## Setup

```bash
pnpm install
cp .env.example .env
```

Then edit `.env` and configure these environment variables:

- `GOOGLE_GEMINI_API_KEY` – Your Google Gemini API key
- `GEMINI_API_KEY` – Same as above (required by ChromaDB embedding function)
- `CHROMA_API_KEY` – Your Chroma Cloud API key
- `CHROMA_DATABASE` – Your Chroma database name
- `CHROMA_TENANT` – Your Chroma tenant ID
- `TOMTOM_API_KEY` – Your TomTom API key for distance calculations

## Development

```bash
pnpm start # runs node src/server.js
# or auto-reload
pnpm start:dev
```

## MySQL via Docker Compose

```bash
docker compose up -d mysql
# stop while keeping data
docker compose stop mysql
```

Configuration values are sourced from `.env` (see `.env.example`). Persistent data is stored in the `mysql_data` named volume so it remains available across container restarts.

The server exposes:

- `GET /health` – service health check
- `POST /tourism/documents` – add or update tourism documents (upsert: updates if ID exists, inserts if new).

  Request body:
  ```json
  {
    "ids": ["id-1"],
    "documents": ["document text"],
    "metadatas": [{
      "kode_wilayah": "3304012001",
      "latitude": -7.4,
      "longitude": 109.7,
      "...": "other metadata"
    }]
  }
  ```
  > Note: `kode_wilayah` is used for weather data, while `latitude` and `longitude` are used for distance calculations. You can also add any other custom metadata fields.

  Response:
  ```json
  {
    "success": true,
    "message": "Documents added successfully",
    "count": 1
  }
  ```
- `POST /tourism/query` – query stored documents.

  Request body:
  ```json
  {
    "queries": ["some query"],
    "nResults": 5
  }
  ```

  Response:
  ```json
  {
    "success": true,
    "data": {
      "ids": [["id-1", "id-2"]],
      "distances": [[0.1, 0.3]],
      "metadatas": [[{...}, {...}]],
      "documents": [["document text 1", "document text 2"]],
      "embeddings": null
    }
  }
  ```
- `DELETE /tourism/documents` – delete tourism documents by IDs.

  Request body:
  ```json
  {
    "ids": ["id-1", "id-2"]
  }
  ```

  Response:
  ```json
  {
    "success": true,
    "message": "Documents deleted successfully",
    "count": 2
  }
  ```
- `POST /chat/query` – handle user question.

  Request body:
  ```json
  {
    "query": "rekomendasi tempat wisata alam"
  }
  ```

  Response:
  ```json
  {
    "success": true,
    "data": {
      "response": "AI-generated response text"
    },
    "timestamp": "2025-12-12T10:30:00.000Z"
  }
  ```

## Notes

- Services mirror the NestJS logic: `TourismService` handles ChromaDB interactions, `LlmService` wraps Gemini, `ChatService` orchestrates tool-calling flow.
- Errors bubble through a shared `AppError` class and `errorHandler` middleware for consistent responses.

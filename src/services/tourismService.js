import { CloudClient } from "chromadb";
import { GoogleGeminiEmbeddingFunction } from "@chroma-core/google-gemini";
import { AppError } from "../utils/appError.js";

export class TourismService {
  constructor() {
    this.client = null;
    this.collection = null;
  }

  async init() {
    try {
      const geminiApiKey = process.env.GOOGLE_GEMINI_API_KEY;
      if (!geminiApiKey) {
        throw new AppError(500, "GOOGLE_GEMINI_API_KEY is not configured");
      }
      const database = process.env.CHROMA_DATABASE;
      if (!database) {
        throw new AppError(500, "CHROMA_DATABASE is not configured");
      }
      const chromaApiKey = process.env.CHROMA_API_KEY;
      if (!chromaApiKey) {
        throw new AppError(500, "CHROMA_API_KEY is not configured");
      }
      const chromaTenant = process.env.CHROMA_TENANT;
      if (!chromaTenant) {
        throw new AppError(500, "CHROMA_TENANT is not configured");
      }

      this.client = new CloudClient({
        database: database,
        apiKey: chromaApiKey,
        tenant: chromaTenant,
      });
      this.collection = await this.client.getOrCreateCollection({
        name: "tourism",
        embeddingFunction: new GoogleGeminiEmbeddingFunction({
          apiKey: geminiApiKey,
        }),
        metadata: {
          description: "contains tourist attraction data",
          created: new Date().toISOString(),
        },
      });
      console.log(
        "[TourismService] Tourism collection initialized successfully",
      );
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error(
        "[TourismService] Failed to initialize tourism collection:",
        error,
      );
      throw new AppError(500, "Failed to initialize tourism database");
    }
  }

  async addDocuments(ids, documents, metadatas) {
    try {
      this.#ensureInitialized();
      if (
        !Array.isArray(ids) ||
        !Array.isArray(documents) ||
        !Array.isArray(metadatas)
      ) {
        throw new AppError(400, "ids, documents, and metadatas must be arrays");
      }
      if (ids.length !== documents.length || ids.length !== metadatas.length) {
        throw new AppError(
          400,
          "ids, documents, and metadatas arrays must be the same length",
        );
      }
      await this.collection.upsert({ ids, documents, metadatas });
      return { count: ids.length };
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }
      console.error("[TourismService] Error adding documents:", error);
      throw new AppError(500, "Failed to add documents to database");
    }
  }

  async queryDocuments(queries, nResults = 1) {
    try {
      this.#ensureInitialized();
      if (!Array.isArray(queries) || queries.length === 0) {
        throw new AppError(400, "queries must be a non-empty array of strings");
      }
      if (
        typeof nResults !== "number" ||
        Number.isNaN(nResults) ||
        nResults < 1
      ) {
        throw new AppError(400, "nResults must be a positive number");
      }
      const result = await this.collection.query({
        queryTexts: queries,
        nResults,
      });
      return result;
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }
      console.error("[TourismService] Error querying documents:", error);
      throw new AppError(500, "Failed to query documents from database");
    }
  }

  async deleteDocuments(ids) {
    try {
      this.#ensureInitialized();
      if (!Array.isArray(ids) || ids.length === 0) {
        throw new AppError(400, "ids must be a non-empty array");
      }
      await this.collection.delete({ ids });
      return { count: ids.length };
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }
      console.error("[TourismService] Error deleting documents:", error);
      throw new AppError(500, "Failed to delete documents from database");
    }
  }

  #ensureInitialized() {
    if (!this.collection) {
      throw new AppError(500, "Tourism collection not initialized");
    }
  }
}

import { GoogleGenAI } from "@google/genai";
import { AppError } from "../utils/appError.js";

export class LlmService {
  constructor() {
    this.client = null;
  }

  async init() {
    const apiKey = process.env.GOOGLE_GEMINI_API_KEY;
    if (!apiKey) {
      throw new AppError(500, "GOOGLE_GEMINI_API_KEY is not configured");
    }
    try {
      this.client = new GoogleGenAI({ apiKey });
      console.log("[LlmService] Gemini AI service initialized successfully");
    } catch (error) {
      console.error(
        "[LlmService] Failed to initialize Gemini AI service:",
        error
      );
      throw new AppError(500, "AI service initialization failed");
    }
  }

  async queryRawGemini(params) {
    this.#ensureInitialized();
    if (!params || !params.model) {
      throw new AppError(400, "Invalid parameters: model is required");
    }
    try {
      const response = await this.client.models.generateContent(params);
      if (!response) {
        throw new AppError(500, "No response from AI model");
      }
      return response;
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }
      console.error("[LlmService] Error querying Gemini model:", error);
      throw new AppError(
        500,
        "Failed to query AI model. Please try again later."
      );
    }
  }

  async queryGemini(query) {
    if (!query || typeof query !== "string" || query.trim().length === 0) {
      throw new AppError(400, "Query cannot be empty");
    }
    try {
      return await this.queryRawGemini({
        model: "gemini-2.5-flash",
        contents: query,
        config: {
          temperature: 0.2,
        },
      });
    } catch (error) {
      throw error;
    }
  }

  async queryGeminiNonThinking(query) {
    if (!query || typeof query !== "string" || query.trim().length === 0) {
      throw new AppError(400, "Query cannot be empty");
    }
    try {
      return await this.queryRawGemini({
        model: "gemini-2.5-flash",
        contents: query,
        config: {
          thinkingConfig: {
            thinkingBudget: 0,
          },
        },
      });
    } catch (error) {
      throw error;
    }
  }

  #ensureInitialized() {
    if (!this.client) {
      throw new AppError(500, "AI service not initialized");
    }
  }
}

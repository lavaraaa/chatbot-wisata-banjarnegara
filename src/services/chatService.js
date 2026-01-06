import { AppError } from "../utils/appError.js";
import { getRecommendationsFunctionDeclaration } from "../functionDeclarations/getRecommendations.js";
import { getInformationFunctionDeclaration } from "../functionDeclarations/getInformation.js";
import { getCommentsFunctionDeclaration } from "../functionDeclarations/getComments.js";
import { getLikesCountFunctionDeclaration } from "../functionDeclarations/getLikesCount.js";
import { getWeatherFunctionDeclaration } from "../functionDeclarations/getWeather.js";
import { getDistanceKmFunctionDeclaration } from "../functionDeclarations/getDistanceKm.js";
import { getMostLikedAttractionsFunctionDeclaration } from "../functionDeclarations/getMostLikedAttractions.js";
import { getTopRatedAttractionsFunctionDeclaration } from "../functionDeclarations/getTopRatedAttractions.js";

export class ChatService {
  constructor(llmService, tourismService, tourismDBService, weatherService, distanceService) {
    this.llmService = llmService;
    this.tourismService = tourismService;
    this.tourismDBService = tourismDBService;
    this.weatherService = weatherService;
    this.distanceService = distanceService;
  }

  async processQuery(query) {
    if (!query || typeof query !== "string" || query.trim().length === 0) {
      throw new AppError(400, "Query cannot be empty");
    }

    try {
      const model = "gemini-2.5-flash";
      let idsContext = null; // Store document IDs from vector DB queries
      let metadatasContext = null; // Store metadata from vector DB queries
      const contents = [
        {
          role: "user",
          parts: [
            {
              text: `You are a helpful assistant that specializes in tourist attraction recommendations.

IMPORTANT: You MUST respond in Bahasa Indonesia (Indonesian language) at all times, regardless of the language used in the user's query.

Guidelines:
1. If the user asks about tourist attraction recommendations (even general ones like "recommend tourist attractions"), you MUST call the get_recommendations function immediately. Never ask users to clarify their preferences first. For general requests, call the function with "general" as criteria.

2. If the user asks for information about a specific tourist attraction BY NAME, call the get_information function with the exact attraction name.

3. IMPORTANT - For queries about likes/comments on recommended attractions:
   - If user asks for recommendations AND wants likes/comments about THE FIRST recommended attraction, you should:
     a) Call get_recommendations first
     b) DO NOT call get_information again
     c) Directly call get_likes_count or get_comments (the system will use the FIRST attraction from recommendations)
   
   - If user asks for likes/comments about a SPECIFIC NAMED attraction (not from recommendations), you should:
     a) Call get_information with the specific attraction name
     b) Then call get_likes_count or get_comments

4. When calling get_comments or get_likes_count:
   - NEVER provide wisata_id parameter
   - The system will automatically use the ID from the most recent get_recommendations or get_information call
   - The system uses the FIRST result from the previous query

5. For weather queries:
   - If the user asks about weather for a specific attraction, call get_information FIRST to get the location details.
   - Then call get_weather. The system will automatically use the location code from the information found.
   - If the user asks about weather generally or for a recommended place, call get_weather directly after recommendations.

6. If the user asks questions unrelated to tourist attractions (like health, technology, general knowledge, etc.), answer directly without calling any function.

7. For distance queries:
   - If the user asks for distance between two places, call get_distance_km with the query
   - The system will automatically find both locations and calculate the distance
   - Example: "how far from Kawah Sikidang to Curug Pitu?" → call get_distance_km("how far from Kawah Sikidang to Curug Pitu?")

8. For queries about most popular/most liked attractions or least popular attractions:
   - Call get_most_liked_attractions with appropriate parameters
   - If user asks for "most popular" or "most liked": use order="desc" (default)
   - If user asks for "least popular" or "unpopular": use order="asc"
   - Default limit is 3, but use user-specified number if mentioned (e.g., "5 tempat terpopuler" → limit=5)
   - Examples: "wisata dengan likes terbanyak?" → get_most_liked_attractions(limit=3, order="desc")
              "3 tempat paling tidak populer" → get_most_liked_attractions(limit=3, order="asc")

9. For queries about highest/lowest rated attractions:
   - Call get_top_rated_attractions with appropriate parameters
   - If user asks for "rating tertinggi" or "best rated": use order="desc" (default)
   - If user asks for "rating terendah" or "worst rated": use order="asc"
   - Default limit is 3, but use user-specified number if mentioned
   - Examples: "wisata dengan rating tertinggi?" → get_top_rated_attractions(limit=3, order="desc")
              "3 tempat rating terendah" → get_top_rated_attractions(limit=3, order="asc")

10. For ticket price queries (harga tiket, HTM, biaya masuk, tiket masuk):
    - Call get_information with the attraction name
    - Look for "Harga Tiket:" field in the response document
    - Format the price as Indonesian Rupiah (e.g., "Rp 10.000" instead of "10000.00")
    - If the price is 0 or 0.00, respond with "Gratis (tidak ada biaya masuk)"
    - Always include the attraction name when answering ticket price questions
    - NEVER guess or make up ticket prices - only use the exact value from the document

CRITICAL RULES:
- After get_recommendations, DO NOT call get_information unless user asks for a different specific attraction
- The first attraction from get_recommendations will be used for subsequent likes/comments queries
- Always call functions in the correct order: recommendations/information FIRST, then likes/comments/weather
- When asking for weather, ensure you have a context of a location (from recommendations or information lookup)

User query: ${query}`,
            },
          ],
        },
      ];
      const config = {
        thinkingConfig: {
          thinkingBudget: 0,
        },
        tools: [
          {
            functionDeclarations: [
              getRecommendationsFunctionDeclaration,
              getInformationFunctionDeclaration,
              getCommentsFunctionDeclaration,
              getLikesCountFunctionDeclaration,
              getWeatherFunctionDeclaration,
              getDistanceKmFunctionDeclaration,
              getMostLikedAttractionsFunctionDeclaration,
              getTopRatedAttractionsFunctionDeclaration,
            ],
          },
        ],
      };

      // Multi-step function calling loop
      let iterationCount = 0;
      const maxIterations = 5;
      let response;

      while (iterationCount < maxIterations) {
        console.log(
          `[ChatService] Iteration ${iterationCount + 1}/${maxIterations}`
        );

        response = await this.llmService.queryRawGemini({
          model,
          contents,
          config,
        });

        const toolCall = response.functionCalls;

        if (!toolCall || toolCall.length === 0) {
          // No more function calls needed, return response
          console.log(
            "[ChatService] No more function calls needed, returning final response"
          );
          return response.text;
        }

        console.log(
          `[ChatService] Function call detected: ${toolCall[0].name}`
        );

        const { name } = toolCall[0];

        if (name === "get_recommendations") {
          const toolResponse = await this.getRecommendations(query, 5);
          const documents = toolResponse?.documents?.[0] ?? [];
          const ids = toolResponse?.ids?.[0] ?? [];
          const metadatas = toolResponse?.metadatas?.[0] ?? [];
          const filteredDocs = Array.isArray(documents)
            ? documents.filter((doc) => doc !== null)
            : [];

          // Store document IDs context for potential follow-up function calls
          if (ids.length > 0) {
            idsContext = ids;
            metadatasContext = metadatas;
          }

          // Extract only titles from metadatas for shorter response
          // Primary: use metadata.title, fallback: extract from document content
          const titles = metadatas.map((meta, index) => {
            if (meta?.title) return meta.title;
            // Fallback: extract from document content using "Judul: ..." pattern
            const doc = filteredDocs[index];
            if (doc) {
              const match = doc.match(/^Judul:\s*(.+)$/m);
              if (match) return match[1].trim();
            }
            return `Wisata ${index + 1}`;
          });

          const functionResponseText = titles.length
            ? `Berikut rekomendasi tempat wisata:\n${titles.map((t, i) => `${i + 1}. ${t}`).join("\n")}`
            : "there are no tourist attractions that meet the user's criteria";

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_information") {
          const toolResponse = await this.getInformation(query);
          const documents = toolResponse?.documents?.[0] ?? [];
          const ids = toolResponse?.ids?.[0] ?? [];
          const metadatas = toolResponse?.metadatas?.[0] ?? [];

          // Store document IDs context for potential follow-up function calls
          if (ids.length > 0) {
            idsContext = ids;
            metadatasContext = metadatas;
          }

          const functionResponseText = Array.isArray(documents)
            ? documents.filter((doc) => doc !== null).join("\n\n") || "information not found"
            : documents || "information not found";

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_comments") {
          let { wisata_id } = toolCall[0].args;

          // Always try to extract from document IDs context for named attractions
          if (idsContext && idsContext.length > 0) {
            wisata_id = idsContext[0];
          } else if (!wisata_id) {
            throw new AppError(
              400,
              "Unable to determine wisata_id. Please specify a tourist attraction first."
            );
          }

          const toolResponse = await this.getComments(wisata_id);
          const functionResponseText = toolResponse.length
            ? `Comments for this tourist attraction (${toolResponse.length
            } comments):\n\n${toolResponse
              .map(
                (comment, index) =>
                  `${index + 1}. User ID ${comment.user_id}: "${comment.isi
                  }" (${new Date(comment.created_at).toLocaleString()})`
              )
              .join("\n")}`
            : "No comments found for this tourist attraction";

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_likes_count") {
          let { wisata_id } = toolCall[0].args;

          // Always try to extract from document IDs context for named attractions
          if (idsContext && idsContext.length > 0) {
            wisata_id = idsContext[0];
          } else if (!wisata_id) {
            throw new AppError(
              400,
              "Unable to determine wisata_id. Please specify a tourist attraction first."
            );
          }

          const toolResponse = await this.getLikesCount(wisata_id);
          const functionResponseText = `This tourist attraction has ${toolResponse} like${toolResponse !== 1 ? "s" : ""
            }`;

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_weather") {
          let { kode_wilayah } = toolCall[0].args;

          // Try to extract from metadata context if available
          if (metadatasContext && metadatasContext.length > 0) {
            const firstMetadata = metadatasContext[0];
            if (firstMetadata && firstMetadata.kode_wilayah) {
              kode_wilayah = firstMetadata.kode_wilayah;
            }
          }

          if (!kode_wilayah) {
            throw new AppError(
              400,
              "Unable to determine region code (kode_wilayah). Please specify a tourist attraction first so I can find its location."
            );
          }

          let functionResponseText;
          try {
            const toolResponse = await this.weatherService.getWeatherByCode(
              kode_wilayah
            );
            functionResponseText = JSON.stringify(toolResponse);
          } catch (error) {
            console.error(
              `[ChatService] Error getting weather for code ${kode_wilayah}:`,
              error
            );
            functionResponseText = `Failed to retrieve weather data for region code ${kode_wilayah}. The service might be unavailable.`;
          }

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_distance_km") {
          const { query } = toolCall[0].args;

          let functionResponseText;
          try {
            functionResponseText = await this.distanceService.getDistanceFromLocations(query);
          } catch (error) {
            console.error("[ChatService] Error calculating distance:", error);
            if (error instanceof AppError) {
              functionResponseText = error.message;
            } else {
              functionResponseText =
                "Gagal menghitung jarak. Silakan coba lagi dengan dua nama lokasi yang berbeda.";
            }
          }

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_most_liked_attractions") {
          const { limit, order } = toolCall[0].args;
          const results = await this.getMostLikedAttractions(
            limit || 3,
            order || "desc"
          );

          const orderText = order === "asc" ? "paling sedikit" : "terbanyak";
          const functionResponseText = results.length
            ? `Berikut ${results.length} tempat wisata dengan likes ${orderText}:\n\n${results
              .map(
                (r, i) =>
                  `${i + 1}. ${r.judul} - ${r.likes_count} like${r.likes_count !== 1 ? "s" : ""
                  }`
              )
              .join("\n")}`
            : "Tidak ada data tempat wisata dengan likes ditemukan.";

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        if (name === "get_top_rated_attractions") {
          const { limit, order } = toolCall[0].args;
          const results = await this.getTopRatedAttractions(
            limit || 3,
            order || "desc"
          );

          const orderText = order === "asc" ? "terendah" : "tertinggi";
          const functionResponseText = results.length
            ? `Berikut ${results.length} tempat wisata dengan rating ${orderText}:\n\n${results
              .map((r, i) => `${i + 1}. ${r.judul} - ⭐ ${r.avg_rating}`)
              .join("\n")}`
            : "Tidak ada data tempat wisata dengan rating ditemukan.";

          contents.push({
            role: "model",
            parts: [
              {
                functionCall: {
                  name,
                  args: toolCall[0].args,
                },
              },
            ],
          });

          contents.push({
            role: "user",
            parts: [
              {
                functionResponse: {
                  name,
                  response: {
                    result: functionResponseText,
                  },
                },
              },
            ],
          });
        }

        // Continue to next iteration
        iterationCount++;
      }

      // If we hit max iterations, return last response or error message
      console.log(
        "[ChatService] Max iterations reached, returning last response"
      );
      return (
        response?.text ||
        "I apologize, but I'm having trouble processing your request. Please try asking in a different way."
      );
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error("[ChatService] Error processing query:", error);
      throw new AppError(
        500,
        "Failed to process your query. Please try again later."
      );
    }
  }

  async getRecommendations(query, nResult = 10) {
    if (!query || query.trim().length === 0) {
      throw new AppError(400, "Query cannot be empty");
    }

    try {
      return await this.tourismService.queryDocuments([query], nResult);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get recommendations");
    }
  }

  async getInformation(query) {
    if (!query || query.trim().length === 0) {
      throw new AppError(400, "Query cannot be empty");
    }

    try {
      return await this.tourismService.queryDocuments([query], 1);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get information");
    }
  }

  async getComments(wisataId) {
    if (!wisataId) {
      throw new AppError(400, "wisata_id cannot be empty");
    }

    try {
      const numericWisataId = parseInt(wisataId, 10);
      if (isNaN(numericWisataId)) {
        throw new AppError(400, "wisata_id must be a valid number");
      }

      return await this.tourismDBService.getComments(numericWisataId);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get comments");
    }
  }

  async getLikesCount(wisataId) {
    if (!wisataId) {
      throw new AppError(400, "wisata_id cannot be empty");
    }

    try {
      const numericWisataId = parseInt(wisataId, 10);
      if (isNaN(numericWisataId)) {
        throw new AppError(400, "wisata_id must be a valid number");
      }

      return await this.tourismDBService.getLikesCount(numericWisataId);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get likes count");
    }
  }

  async getMostLikedAttractions(limit = 3, order = "desc") {
    try {
      return await this.tourismDBService.getMostLikedAttractions(limit, order);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get most liked attractions");
    }
  }

  async getTopRatedAttractions(limit = 3, order = "desc") {
    try {
      return await this.tourismDBService.getTopRatedAttractions(limit, order);
    } catch (error) {
      throw error instanceof AppError
        ? error
        : new AppError(500, "Failed to get top rated attractions");
    }
  }
}

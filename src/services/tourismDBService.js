import { PrismaClient } from "../generated/prisma/client.js";
import { AppError } from "../utils/appError.js";

export class TourismDBService {
  constructor() {
    this.prisma = new PrismaClient();
  }

  /**
   * Get comments for a specific tourism destination
   * @param {number} wisataId - The ID of the tourism destination
   * @returns {Promise<Array>} Array of comments with user information
   */
  async getComments(wisataId) {
    try {
      if (!wisataId || typeof wisataId !== "number") {
        throw new AppError(400, "wisata_id must be a valid number");
      }

      const comments = await this.prisma.komentar.findMany({
        where: {
          wisata_id: wisataId,
        },
        select: {
          id: true,
          user_id: true,
          wisata_id: true,
          isi: true,
          created_at: true,
          parent_id: true,
        },
        orderBy: {
          created_at: "desc",
        },
      });

      return comments;
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error("[TourismDBService] Error fetching comments:", error);
      throw new AppError(500, "Failed to fetch comments from database");
    }
  }

  /**
   * Get likes count for a specific tourism destination
   * @param {number} wisataId - The ID of the tourism destination
   * @returns {Promise<number>} Count of likes
   */
  async getLikesCount(wisataId) {
    try {
      if (!wisataId || typeof wisataId !== "number") {
        throw new AppError(400, "wisata_id must be a valid number");
      }

      console.log(`[TourismDBService] Querying likes for wisata_id: ${wisataId}`);

      const likesCount = await this.prisma.likes.count({
        where: {
          wisata_id: wisataId,
        },
      });

      console.log(`[TourismDBService] Found ${likesCount} likes for wisata_id: ${wisataId}`);
      return likesCount;
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error("[TourismDBService] Error fetching likes count:", error);
      throw new AppError(500, "Failed to fetch likes count from database");
    }
  }

  /**
   * Get tourist attractions ranked by number of likes
   * @param {number} limit - Number of attractions to return (default: 3)
   * @param {string} order - Sort order: 'desc' for most likes, 'asc' for least likes (default: 'desc')
   * @returns {Promise<Array>} Array of attractions with likes count
   */
  async getMostLikedAttractions(limit = 3, order = "desc") {
    try {
      const validLimit = Math.max(1, Math.min(limit, 20)); // Clamp between 1 and 20
      const sortOrder = order === "asc" ? "asc" : "desc";

      console.log(
        `[TourismDBService] Querying top ${validLimit} attractions by likes (${sortOrder})`
      );

      // Use raw query for efficient groupBy with count
      // Need separate queries for different sort orders since Prisma doesn't support dynamic ORDER BY
      const results =
        sortOrder === "desc"
          ? await this.prisma.$queryRaw`
              SELECT 
                w.id,
                w.judul,
                COUNT(l.id) as likes_count
              FROM wisata w
              LEFT JOIN likes l ON w.id = l.wisata_id
              GROUP BY w.id, w.judul
              ORDER BY likes_count DESC
              LIMIT ${validLimit}
            `
          : await this.prisma.$queryRaw`
              SELECT 
                w.id,
                w.judul,
                COUNT(l.id) as likes_count
              FROM wisata w
              LEFT JOIN likes l ON w.id = l.wisata_id
              GROUP BY w.id, w.judul
              ORDER BY likes_count ASC
              LIMIT ${validLimit}
            `;

      console.log(
        `[TourismDBService] Found ${results.length} attractions ranked by likes`
      );

      // Convert BigInt to Number for JSON serialization
      return results.map((r) => ({
        id: Number(r.id),
        judul: r.judul,
        likes_count: Number(r.likes_count),
      }));
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error(
        "[TourismDBService] Error fetching most liked attractions:",
        error
      );
      throw new AppError(
        500,
        "Failed to fetch most liked attractions from database"
      );
    }
  }

  /**
   * Get tourist attractions ranked by average rating
   * @param {number} limit - Number of attractions to return (default: 3)
   * @param {string} order - Sort order: 'desc' for highest rating, 'asc' for lowest rating (default: 'desc')
   * @returns {Promise<Array>} Array of attractions with average rating
   */
  async getTopRatedAttractions(limit = 3, order = "desc") {
    try {
      const validLimit = Math.max(1, Math.min(limit, 20)); // Clamp between 1 and 20
      const sortOrder = order === "asc" ? "asc" : "desc";

      console.log(
        `[TourismDBService] Querying top ${validLimit} attractions by rating (${sortOrder})`
      );

      // Use COALESCE to handle attractions without ratings (rating = 0)
      const results =
        sortOrder === "desc"
          ? await this.prisma.$queryRaw`
              SELECT 
                w.id,
                w.judul,
                COALESCE(AVG(r.rating), 0) as avg_rating
              FROM wisata w
              LEFT JOIN rating r ON w.id = r.wisata_id
              GROUP BY w.id, w.judul
              ORDER BY avg_rating DESC
              LIMIT ${validLimit}
            `
          : await this.prisma.$queryRaw`
              SELECT 
                w.id,
                w.judul,
                COALESCE(AVG(r.rating), 0) as avg_rating
              FROM wisata w
              LEFT JOIN rating r ON w.id = r.wisata_id
              GROUP BY w.id, w.judul
              ORDER BY avg_rating ASC
              LIMIT ${validLimit}
            `;

      console.log(
        `[TourismDBService] Found ${results.length} attractions ranked by rating`
      );

      // Convert BigInt to Number and format avg_rating for JSON serialization
      return results.map((r) => ({
        id: Number(r.id),
        judul: r.judul,
        avg_rating: Number(Number(r.avg_rating).toFixed(1)),
      }));
    } catch (error) {
      if (error instanceof AppError) {
        throw error;
      }

      console.error(
        "[TourismDBService] Error fetching top rated attractions:",
        error
      );
      throw new AppError(
        500,
        "Failed to fetch top rated attractions from database"
      );
    }
  }

  /**
   * Disconnect Prisma client
   */
  async disconnect() {
    await this.prisma.$disconnect();
  }
}

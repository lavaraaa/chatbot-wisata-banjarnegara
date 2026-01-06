export const getCommentsFunctionDeclaration = {
  name: "get_comments",
  description:
    "Get comments/reviews from users for a specific tourist attraction. Use this when users ask about comments, reviews, or feedback about a tourist destination. The wisata_id will be automatically extracted from the previous get_recommendations or get_information call if not provided.",
  parameters: {
    type: "OBJECT",
    properties: {
      wisata_id: {
        type: "NUMBER",
        description:
          "The ID of the tourist attraction to get comments for. Optional - will be extracted from previous query if not provided.",
      },
    },
    required: [],
  },
};

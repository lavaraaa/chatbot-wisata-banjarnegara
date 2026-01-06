export const getRecommendationsFunctionDeclaration = {
  name: 'get_recommendations',
  description:
    'Get recommendations for tourist attractions according to user criteria. This function will return all relevant tourist attractions from the database. Call this function when user asks for tourist attraction recommendations. For general requests without specific criteria, use "general" or empty string as criteria to get random recommendations.',
  parameters: {
    type: 'object',
    properties: {
      criteria: {
        type: 'string',
        description:
          'User criteria details for recommended tourist attractions. Use "general" or empty string for general/vague requests to get random recommendations.',
      },
    },
    required: [],
  },
};

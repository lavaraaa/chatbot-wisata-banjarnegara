export const getInformationFunctionDeclaration = {
  name: 'get_information',
  description:
    'Get detailed information about a specific tourist attraction. Call this function when the user asks for information about a particular place.',
  parameters: {
    type: 'object',
    properties: {
      attraction: {
        type: 'string',
        description: 'The name or identifier of the tourist attraction.',
      },
    },
    required: [],
  },
};

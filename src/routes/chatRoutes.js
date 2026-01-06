import { Router } from 'express';

export function createChatRouter(chatService) {
  const router = Router();

  router.post('/query', async (req, res, next) => {
    try {
      const { query } = req.body;
      const response = await chatService.processQuery(query);

      res.json({
        success: true,
        data: {
          response: response || 'No response generated',
        },
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      next(error);
    }
  });

  return router;
}

import { AppError } from './appError.js';

export function errorHandler(err, _req, res, _next) {
  const status = err instanceof AppError ? err.status : 500;
  const payload = {
    success: false,
    message: err.message || 'Internal Server Error',
  };

  if (err?.details) {
    payload.details = err.details;
  }

  if (process.env.NODE_ENV !== 'production') {
    payload.stack = err.stack;
  }

  res.status(status).json(payload);
}

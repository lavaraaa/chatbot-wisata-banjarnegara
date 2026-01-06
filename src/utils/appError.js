export class AppError extends Error {
  constructor(status, message, details) {
    super(message);
    this.status = status;
    this.details = details;
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, AppError);
    }
  }
}

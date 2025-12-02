// Runtime env file that can be edited per-deployment without rebuilding the app.
// Default points to the same origin under /api (matches src/environments/environment.prod.ts).
// You can override this file in different deployments to change the API URL.
window.__env = window.__env || {};
window.__env.apiUrl = '/api';


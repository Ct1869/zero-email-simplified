// Simplified environment variables - no Cloudflare Workers dependencies

export type ZeroEnv = {
  // Core Application
  NODE_ENV: 'local' | 'development' | 'production';
  PORT: string;
  VITE_PUBLIC_APP_URL: string;
  VITE_PUBLIC_BACKEND_URL: string;
  
  // Database
  DATABASE_URL: string;
  
  // Authentication
  BETTER_AUTH_SECRET: string;
  BETTER_AUTH_URL: string;
  COOKIE_DOMAIN: string;
  BETTER_AUTH_TRUSTED_ORIGINS?: string;
  
  // Google OAuth (Gmail)
  GOOGLE_CLIENT_ID: string;
  GOOGLE_CLIENT_SECRET: string;
  GOOGLE_REDIRECT_URI?: string;
  
  // Microsoft OAuth (Outlook)
  MICROSOFT_CLIENT_ID?: string;
  MICROSOFT_CLIENT_SECRET?: string;
  
  // Proton Mail
  PROTON_APP_PASSWORD?: string;
  
  // Redis
  REDIS_URL: string;
  REDIS_TOKEN: string;
  
  // Email Sending (Optional)
  RESEND_API_KEY?: string;
  
  // Encryption (Optional)
  AUTUMN_SECRET_KEY?: string;
  
  // Analytics (Optional)
  VITE_PUBLIC_POSTHOG_KEY?: string;
  VITE_PUBLIC_POSTHOG_HOST?: string;
  AXIOM_API_TOKEN?: string;
  AXIOM_DATASET?: string;
  
  // GitHub OAuth (Optional)
  GITHUB_CLIENT_ID?: string;
  GITHUB_CLIENT_SECRET?: string;
  
  // Meet Integration (Optional)
  MEET_AUTH_HEADER?: string;
  MEET_API_URL?: string;
  ENABLE_MEET?: 'true' | 'false';
  
  // Development
  REACT_SCAN?: string;
  DEV_PROXY?: string;
};

// Get environment variables from process.env
export const env: ZeroEnv = {
  NODE_ENV: (process.env.NODE_ENV as ZeroEnv['NODE_ENV']) || 'development',
  PORT: process.env.PORT || '8787',
  VITE_PUBLIC_APP_URL: process.env.VITE_PUBLIC_APP_URL || 'http://localhost:3000',
  VITE_PUBLIC_BACKEND_URL: process.env.VITE_PUBLIC_BACKEND_URL || 'http://localhost:8787',
  
  DATABASE_URL: process.env.DATABASE_URL || '',
  
  BETTER_AUTH_SECRET: process.env.BETTER_AUTH_SECRET || '',
  BETTER_AUTH_URL: process.env.BETTER_AUTH_URL || 'http://localhost:3000',
  COOKIE_DOMAIN: process.env.COOKIE_DOMAIN || 'localhost',
  BETTER_AUTH_TRUSTED_ORIGINS: process.env.BETTER_AUTH_TRUSTED_ORIGINS,
  
  GOOGLE_CLIENT_ID: process.env.GOOGLE_CLIENT_ID || '',
  GOOGLE_CLIENT_SECRET: process.env.GOOGLE_CLIENT_SECRET || '',
  GOOGLE_REDIRECT_URI: process.env.GOOGLE_REDIRECT_URI,
  
  MICROSOFT_CLIENT_ID: process.env.MICROSOFT_CLIENT_ID,
  MICROSOFT_CLIENT_SECRET: process.env.MICROSOFT_CLIENT_SECRET,
  
  PROTON_APP_PASSWORD: process.env.PROTON_APP_PASSWORD,
  
  REDIS_URL: process.env.REDIS_URL || 'http://localhost:8079',
  REDIS_TOKEN: process.env.REDIS_TOKEN || 'upstash-local-token',
  
  RESEND_API_KEY: process.env.RESEND_API_KEY,
  AUTUMN_SECRET_KEY: process.env.AUTUMN_SECRET_KEY,
  
  VITE_PUBLIC_POSTHOG_KEY: process.env.VITE_PUBLIC_POSTHOG_KEY,
  VITE_PUBLIC_POSTHOG_HOST: process.env.VITE_PUBLIC_POSTHOG_HOST,
  AXIOM_API_TOKEN: process.env.AXIOM_API_TOKEN,
  AXIOM_DATASET: process.env.AXIOM_DATASET,
  
  GITHUB_CLIENT_ID: process.env.GITHUB_CLIENT_ID,
  GITHUB_CLIENT_SECRET: process.env.GITHUB_CLIENT_SECRET,
  
  MEET_AUTH_HEADER: process.env.MEET_AUTH_HEADER,
  MEET_API_URL: process.env.MEET_API_URL,
  ENABLE_MEET: process.env.ENABLE_MEET as 'true' | 'false' | undefined,
  
  REACT_SCAN: process.env.REACT_SCAN,
  DEV_PROXY: process.env.DEV_PROXY,
};

// Validate required environment variables
const requiredVars = [
  'DATABASE_URL',
  'BETTER_AUTH_SECRET',
  'GOOGLE_CLIENT_ID',
  'GOOGLE_CLIENT_SECRET',
  'REDIS_URL',
  'REDIS_TOKEN',
] as const;

for (const varName of requiredVars) {
  if (!env[varName]) {
    console.warn(`⚠️  Warning: Required environment variable ${varName} is not set`);
  }
}

export default env;


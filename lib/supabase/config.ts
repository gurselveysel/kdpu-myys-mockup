// Publishable values are safe for browser delivery; RLS remains the authorization boundary.
// Environment variables override these preview-only defaults.
export const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || "https://xpjkrwzgimdxsasqszfi.supabase.co";
export const supabasePublishableKey = process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY || "sb_publishable_v_AI0cizKIbiJqeqWYHDSQ__g2fSY4p";

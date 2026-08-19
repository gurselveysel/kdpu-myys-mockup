import { NextResponse } from "next/server";
import { createClient } from "@/lib/supabase/server";

export async function GET(){try{const client=await createClient();const {count,error}=await client.from("programs").select("id",{count:"exact",head:true}).eq("is_published",true);if(error)throw error;return NextResponse.json({status:"ok",database:"connected",publishedPrograms:count??0,demo:true});}catch{return NextResponse.json({status:"degraded",database:"unavailable",demo:true},{status:503});}}

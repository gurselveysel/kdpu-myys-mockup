"use client";
import { useRouter } from "next/navigation";
import { roles } from "@/lib/demo-data";
import type { RoleKey } from "@/lib/types";

export function DemoLogin(){const router=useRouter();function choose(key:RoleKey){localStorage.setItem("myys-demo-role",key);localStorage.setItem("myys-demo-role-name",roles.find(r=>r.key===key)?.name??key);router.push("/panel");}return <div className="role-grid">{roles.map(role=><button className="role-button" key={role.key} onClick={()=>choose(role.key)}><b>{role.name}</b><span className="hint">{role.description}</span></button>)}</div>}

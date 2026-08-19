"use client";
import Link from "next/link";
import { useSyncExternalStore } from "react";
import { BarChart3, Bell, FilePlus2, Files, Gauge, GitPullRequest, Landmark, LogOut, Network, SearchCheck } from "lucide-react";
import { Brand } from "./brand";

const items = [
  ["/panel", "Genel görünüm", Gauge],
  ["/panel/basvurular", "Başvurular", Files],
  ["/panel/basvurular/yeni", "Yeni başvuru", FilePlus2],
  ["/panel/inceleme", "Komisyon", SearchCheck],
  ["/panel/entegrasyonlar", "Entegrasyonlar", Network],
  ["/panel/finans", "Mali süreçler", Landmark],
  ["/panel/raporlar", "Raporlar", BarChart3],
  ["/panel/denetim", "Denetim izi", GitPullRequest],
];

function subscribeRole(callback:()=>void){window.addEventListener("storage",callback);return()=>window.removeEventListener("storage",callback)}
function getRole(){return localStorage.getItem("myys-demo-role-name")||"Sistem yöneticisi"}
export function PanelShell({children}:{children:React.ReactNode}){const role=useSyncExternalStore(subscribeRole,getRole,()=>"Demo kullanıcı");return <div className="panel"><div className="panel-shell"><aside className="sidebar"><Brand compact/><nav className="side-nav" aria-label="Panel menüsü">{items.map(([href,label,Icon])=><Link href={href as string} key={href as string}><Icon size={18}/><span>{label as string}</span></Link>)}</nav></aside><div className="panel-main"><header className="panel-top"><div><b>MYYS Kontrollü Pilot</b><div className="hint">Gerçek kurumsal sisteme bağlı değildir</div></div><div style={{display:"flex",alignItems:"center",gap:12}}><Bell size={18}/><span className="role-chip">{role}</span><Link href="/giris" aria-label="Çıkış"><LogOut size={18}/></Link></div></header><main id="main" className="panel-content">{children}</main></div></div></div>}

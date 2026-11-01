// ============================================================
// frontend/src/config/environment.js
// Configuração centralizada de ambientes (Vercel, Hostinger, Local, VPS)
// ============================================================

/**
 * MODO DE USO:
 * 1. Para trocar de ambiente, você pode simplesmente mudar a linha abaixo (PRODUÇÃO / VERCEL / LOCAL)
 *    OU definir a variável de ambiente VITE_API_URL no painel da sua hospedagem (Vercel / Hostinger / etc).
 */

const isBrowser = typeof window !== "undefined";
const isVercel = isBrowser && window.location.hostname.includes("vercel.app");
const isLocalhost = isBrowser && (window.location.hostname === "localhost" || window.location.hostname === "127.0.0.1");

// Se houver variável de ambiente no Vite/Vercel/Hostinger, ela tem prioridade total:
const ENV_API_URL = import.meta.env.VITE_API_URL;

// Caso não esteja configurado no painel da hospedagem, você pode escolher manualmente aqui:
const AMBIENTES = {
    // 1. Desenvolvimento local ou na mesma rede Wi-Fi pelo celular
    local: isBrowser ? `http://${window.location.hostname}:3001` : "http://localhost:3001",

    // 2. Vercel (utiliza o rewrite proxy serverless /api -> Nginx VM sem mixed-content)
    vercel: "/api",

    // 3. Sua VM Oracle Cloud direta via Nginx (com prefixo /furdunco-api)
    oracle_vm: "http://137.131.185.243/furdunco-api"
};

// 🎯 DETECÇÃO INTELIGENTE DE AMBIENTE:
let rawUrl = ENV_API_URL;
if (!rawUrl) {
    if (isVercel) {
        rawUrl = AMBIENTES.vercel;
    } else if (isLocalhost) {
        rawUrl = AMBIENTES.local;
    } else {
        rawUrl = AMBIENTES.oracle_vm;
    }
}

// Exportação final da URL da API utilizada por todo o frontend (sem barra final)
export const BASE_API_URL = (rawUrl || "").replace(/\/+$/, "");

// Helper seguro para montar URL de imagem sem barra duplicada
export const getImagemUrl = (caminho) => {
    if (!caminho) return null;
    if (caminho.startsWith("http://") || caminho.startsWith("https://")) return caminho;
    const cleanPath = caminho.startsWith("/") ? caminho : `/${caminho}`;
    return `${BASE_API_URL}${cleanPath}`;
};

console.log(`[Cardápio Furdunço] Conectado na API: ${BASE_API_URL || "(relativa /api)"}`);

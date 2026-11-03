// ============================================================
// backend/src/middleware/authMiddleware.js
// Verifica se o usuário está autenticado e se é admin
// ============================================================

const jwt = require("jsonwebtoken");
const { requiredSecret } = require("../config/secrets");

const JWT_SECRET = requiredSecret("JWT_SECRET", 24);

// Middleware 1 — verifica se o token JWT é válido
const verificarToken = (req, res, next) => {
    const authHeader = req.headers["authorization"];
    // O token vem no header assim: "Bearer eyJhbGciOi..."
    const token = authHeader && authHeader.split(" ")[1];

    if (!token) {
        return res.status(401).json({ erro: "Acesso negado. Token não fornecido." });
    }

    jwt.verify(token, JWT_SECRET, (erro, decoded) => {
        if (erro) {
            return res.status(403).json({ erro: "Token inválido ou expirado." });
        }
        req.usuario = decoded; // salva os dados do usuário no request
        next();
    });
};

// Middleware 2 — permite apenas usuários com role "admin"
const apenasAdmin = (req, res, next) => {
    if (req.usuario.role !== "admin") {
        return res.status(403).json({ erro: "Acesso permitido somente para administradores." });
    }
    next();
};

module.exports = { verificarToken, apenasAdmin };

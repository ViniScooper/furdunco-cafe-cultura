require("dotenv").config();
require("dotenv").config({ path: require("path").resolve(__dirname, "../.env") });

const mysql = require("mysql2");
const bcrypt = require("bcryptjs");

const { ADMIN_NAME, ADMIN_EMAIL, ADMIN_PASSWORD } = process.env;
if (!ADMIN_NAME || !ADMIN_EMAIL || !ADMIN_PASSWORD || ADMIN_PASSWORD.length < 12) {
    console.error("Defina ADMIN_NAME, ADMIN_EMAIL e ADMIN_PASSWORD (mínimo 12 caracteres) no ambiente.");
    process.exit(1);
}

const db = mysql.createConnection({
    host: process.env.DB_HOST || "localhost",
    user: process.env.DB_USER || "root",
    password: process.env.DB_PASSWORD || "",
    database: process.env.DB_NAME || "furdunco_db",
    port: Number(process.env.DB_PORT) || 3306,
    charset: "utf8mb4"
});

(async () => {
    try {
        const hash = await bcrypt.hash(ADMIN_PASSWORD, 12);
        db.query(
            "INSERT INTO usuario (nome, email, senha, role) VALUES (?, ?, ?, 'admin')",
            [ADMIN_NAME.trim(), ADMIN_EMAIL.trim().toLowerCase(), hash],
            (error) => {
                if (error) {
                    console.error(error.code === "ER_DUP_ENTRY" ? "Este email já existe." : error.message);
                    process.exitCode = 1;
                } else {
                    console.log("Administrador inicial criado.");
                }
                db.end();
            }
        );
    } catch (error) {
        console.error(error.message);
        db.end();
        process.exitCode = 1;
    }
})();

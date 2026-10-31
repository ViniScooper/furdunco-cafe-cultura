// ============================================================
// backend/seed-furdunco.js — Popula o cardápio oficial do Furdunço - Café e Cultura
// ============================================================

const fs   = require("fs");
const path = require("path");
const db   = require("./src/config/database");

const jsonPath = path.join(__dirname, "cardapio_furdunco.json");
if (!fs.existsSync(jsonPath)) {
    console.error("❌ Arquivo cardapio_furdunco.json não encontrado!");
    process.exit(1);
}

const catalog = JSON.parse(fs.readFileSync(jsonPath, "utf-8"));

const iconMap = {
    "entradinhas": "🍟",
    "docinhos": "🍰",
    "regionais": "🌽",
    "ovos e toasts": "🍳",
    "sanduíches": "🥪",
    "sanduiches": "🥪",
    "menu executivo": "🍽️",
    "saladas": "🥗",
    "pratos quentes": "🍲",
    "menu kids": "🧒",
    "piquenique": "🧺",
    "veganos": "🌱",
    "espresso e derivados": "☕",
    "cafés filtrados": "☕",
    "cafes filtrados": "☕",
    "cafés gelados": "🧊",
    "cafes gelados": "🧊",
    "cold brew": "🥃",
    "frapês": "🥤",
    "frapes": "🥤",
    "diversos": "✨",
    "drinks": "🍹",
    "bebidas": "🧃",
    "vinhos": "🍷",
    "acompanhamentos e porções": "🧆",
    "acompanhamentos e porcoes": "🧆",
    "happy hour": "🍺"
};

const query = (sql, params = []) => {
    return new Promise((resolve, reject) => {
        db.query(sql, params, (err, res) => {
            if (err) return reject(err);
            resolve(res);
        });
    });
};

async function rodarSeed() {
    console.log("☕ [Furdunço] Iniciando carga de cardápio oficial...");

    try {
        // 1. Configuração inicial
        await query(`
            INSERT INTO configuracao (id, hh_ativo, hh_dias, hh_inicio, hh_fim, instagram_url)
            VALUES (1, 1, 'Quinta a Sábado', '17:00', '20:00', 'https://www.instagram.com/furduncocafecultura/')
            ON DUPLICATE KEY UPDATE instagram_url = VALUES(instagram_url)
        `);
        console.log("✅ Configuração padrão atualizada.");

        // 2. Usuário Administrador (admin@furdunco.com / admin123)
        await query(`
            INSERT INTO usuario (nome, email, senha, role)
            VALUES ('Administrador Furdunço', 'admin@furdunco.com', '$2a$10$vI8aWBnW3fID.ZQ4/ZOIj.qU5vY3K5x1hT.0aY844hXq9E3l9Geq6', 'admin')
            ON DUPLICATE KEY UPDATE nome = VALUES(nome)
        `);
        console.log("✅ Usuário Admin padrão garantido (admin@furdunco.com / admin123).");

        // 3. Inserir Categorias
        let ordem = 1;
        for (const cat of catalog) {
            const icone = iconMap[cat.categoria.toLowerCase()] || "🍴";
            await query(`
                INSERT INTO categoria (nome, icone, ordem)
                VALUES (?, ?, ?)
                ON DUPLICATE KEY UPDATE icone = VALUES(icone), ordem = VALUES(ordem)
            `, [cat.categoria, icone, ordem++]);
        }
        console.log(`✅ ${catalog.length} categorias cadastradas com sucesso.`);

        // 4. Inserir Pratos
        let totalInseridos = 0;
        for (const cat of catalog) {
            const isHH = cat.categoria.toLowerCase().includes("happy hour") ? 1 : 0;
            for (const p of cat.pratos) {
                await query(`
                    INSERT INTO prato (nome, descricao, preco, categoria, happy_hour, imagem)
                    VALUES (?, ?, ?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE
                        descricao = VALUES(descricao),
                        preco = VALUES(preco),
                        categoria = VALUES(categoria),
                        imagem = VALUES(imagem)
                `, [p.nome, p.descricao || "", p.preco, cat.categoria, isHH, p.imagem_url || null]);
                totalInseridos++;
            }
        }
        console.log(`🎉 Sucesso! ${totalInseridos} pratos/bebidas inseridos no cardápio do Furdunço!`);

        process.exit(0);
    } catch (err) {
        console.error("❌ Erro durante o seed:", err.message);
        process.exit(1);
    }
}

rodarSeed();

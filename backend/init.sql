-- ============================================================
-- init.sql — Inicialização do Banco de Dados Furdunço - Café e Cultura
-- ============================================================

CREATE DATABASE IF NOT EXISTS furdunco_db;
USE furdunco_db;

-- 1. Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') DEFAULT 'user',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabela de Categorias
CREATE TABLE IF NOT EXISTS categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    icone VARCHAR(10) NOT NULL DEFAULT '🍴',
    imagem VARCHAR(255) DEFAULT NULL,
    ordem INT DEFAULT 0,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabela de Pratos
CREATE TABLE IF NOT EXISTS prato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    categoria VARCHAR(50) DEFAULT 'Cardápio',
    categoria_secundaria VARCHAR(100) DEFAULT NULL,
    happy_hour TINYINT(1) DEFAULT 0,
    imagem VARCHAR(500) DEFAULT NULL,
    taxa_embalagem DECIMAL(10, 2) DEFAULT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabela de Configurações
CREATE TABLE IF NOT EXISTS configuracao (
    id INT PRIMARY KEY DEFAULT 1,
    hh_ativo TINYINT(1) DEFAULT 1,
    hh_dias VARCHAR(255) DEFAULT 'Quinta a Sábado',
    hh_inicio VARCHAR(10) DEFAULT '17:00',
    hh_fim VARCHAR(10) DEFAULT '20:00',
    hh_apenas_local TINYINT(1) DEFAULT 1,
    delivery_ativo TINYINT(1) DEFAULT 1,
    delivery_tempo VARCHAR(50) DEFAULT '30 a 50 min',
    delivery_taxa_padrao DECIMAL(10,2) DEFAULT 7.00,
    delivery_pedido_minimo DECIMAL(10,2) DEFAULT 0.00,
    delivery_modo VARCHAR(20) DEFAULT 'km',
    delivery_taxa_km DECIMAL(10,2) DEFAULT 2.00,
    delivery_taxa_base DECIMAL(10,2) DEFAULT 5.00,
    delivery_raio_maximo DECIMAL(10,2) DEFAULT 10.00,
    delivery_taxa_embalagem DECIMAL(10,2) DEFAULT 0.00,
    delivery_embalagem_tipo VARCHAR(20) DEFAULT 'pedido',
    instagram_url VARCHAR(255) DEFAULT 'https://www.instagram.com/furduncocafecultura/',
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Inserção das Configurações padrão
INSERT INTO configuracao (id, hh_ativo, hh_dias, hh_inicio, hh_fim, instagram_url)
VALUES (1, 1, 'Quinta a Sábado', '17:00', '20:00', 'https://www.instagram.com/furduncocafecultura/')
ON DUPLICATE KEY UPDATE id=1;

-- Crie o primeiro administrador com `npm run bootstrap-admin` no backend.

-- 5. Inserção das Categorias do Furdunço
INSERT INTO categoria (nome, icone, ordem) VALUES
    ('Entradinhas', '🍟', 1),
    ('Docinhos', '🍰', 2),
    ('Regionais', '🌽', 3),
    ('Ovos e Toasts', '🍳', 4),
    ('Sanduíches', '🥪', 5),
    ('Saladas', '🥗', 6),
    ('Pratos quentes', '🍲', 7),
    ('Menu Kids', '🧒', 8),
    ('Piquenique', '🧺', 9),
    ('Veganos', '🌱', 10),
    ('Espresso e Derivados', '☕', 11),
    ('Cafés Filtrados', '☕', 12),
    ('Cafés Gelados', '🧊', 13),
    ('Cold Brew', '🥃', 14),
    ('Frapês', '🥤', 15),
    ('Diversos', '✨', 16),
    ('Drinks', '🍹', 17),
    ('Bebidas', '🧃', 18),
    ('Vinhos', '🍷', 19),
    ('Acompanhamentos e porções', '🧆', 20),
    ('Happy Hour', '🍺', 21)
ON DUPLICATE KEY UPDATE icone = VALUES(icone), ordem = VALUES(ordem);

-- 6. Inserção dos Pratos e Bebidas (125 itens reais)
INSERT INTO prato (nome, descricao, preco, categoria, happy_hour, imagem) VALUES
    ('Batata frita', '', 22.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/5e9e3846b0bb88a6b4c62bf8d2b122d9.jpg'),
    ('Brie no forno', 'Queijo brie derretido no forno com jamon e geleia de frutas amarelas. Acompanha porção de torradas.', 59.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/e8587cf6d0ba64bca31676b3cbed6741.jpg'),
    ('Carpaccio', 'Ao molho de mostarda doce com alcaparras, rúcula, tomatinho confit e parmesão. Acompanha porção de torradas.', 52.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/20ee004cef3533314f2733b887877305.jpg'),
    ('Cestinha de pães com pastinhas', 'Porção de mix de pães (pão fofinho, torradas e pão italiano) com homus, tomatinho confit e guacamole.', 42.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/4c427e4cb68e4eff394286e7c27492a3.jpg'),
    ('Empada', 'Sabores: frango, camarão e queijo do reino', 15.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/a41609e40e5d1d3b698b97c8c0cd3b65.jpg'),
    ('Iscas de frango empanadas', 'Iscas de frango empanadas. Acompanha molho barbecue de goiabada.', 25.00, 'Entradinhas', 0, '/static/acontece/images/produto.jpg'),
    ('Mini coxinha', 'Porção com 8 unidades.', 22.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/9de9466a512a03b160c11478d87b292d.jpg'),
    ('Mini croissant', 'Porção com 5 unidades. Acompanha requeijão e geleia de frutas amarelas.', 24.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/895c348e97ffb90108460cbe741a99fd.jpg'),
    ('Pão de queijo tradicional', 'Pão de queijo feito artesanalmente na casa. Porção com 5 unidades.', 18.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/a70d4938d33053a83c37bdfd4b88df09.jpg'),
    ('Pão fofinho na chapa', 'Porção com 3 unidades. Acompanha requeijão e geleia a sua escolha.', 20.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/7406ea7cade0f6f915bcfeb9ee0aa86a.jpg'),
    ('Pão fofinho recheado', 'porção com 4 unidades. Sabores: frango, queijo do reino ou camarão.', 27.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/5d5824fc8b6cc74adfc865eb1ecc6be2.jpg'),
    ('Pastel de queijo', 'Porção com 6 unidades.', 29.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/9cb25ad91a30e1be52eeef4b181157b1.jpg'),
    ('Quiche', 'Sabores: muçarela com tomate confit, gorgonzola com geleia de maçã, brie com geleia de frutas amarelas, alho poró.', 17.00, 'Entradinhas', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/c93668726ac3e87532084def5863cf3e.jpg'),
    ('Bolo do dia', 'Fatia de bolo. Consultar o sabor do dia.', 18.00, 'Docinhos', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/7a1ea81bb3799aa2371bbb7ecba75a06.jpg'),
    ('Brigadeiro no pote', 'Brigadeiro ou bem casado no pote com granulado para comer de colher.', 14.00, 'Docinhos', 0, 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/n/gr88wz9mdro0/b/furdunco-fotos/o/thumb/854f9306a61be6db575bc61b56f82be2.jpg'),
    ('Brownie com Sorvete', 'Brownie de chocolate com sorvete de creme e calda de chocolate.', 28.00, 'Docinhos', 0, NULL),
    ('Cartola', 'Banana grelhada com queijo coalho assado, canela e açúcar.', 28.00, 'Docinhos', 0, NULL),
    ('Cheesecake', 'Cheesecake com calda de frutas vermelhas ou maracujá.', 28.00, 'Docinhos', 0, NULL),
    ('Cookie Vegano', 'Cookie vegano sem glúten. Sabores tradicional e chocolate.', 15.00, 'Docinhos', 0, NULL),
    ('Mini Bolo', 'Mini bolo com calda. Massa: chocolate, cenoura ou laranja. Calda: chocolate ou caramelo salgado.', 18.00, 'Docinhos', 0, NULL),
    ('Salada de Frutas', 'Salada de frutas com mel, granola e iogurte.', 22.00, 'Docinhos', 0, NULL),
    ('Taça de Banoffee', 'Taça gelada de banoffee com sorvete de creme.', 29.00, 'Docinhos', 0, NULL),
    ('Torta Alemã', 'Fatia de torta alemã.', 20.00, 'Docinhos', 0, NULL),
    ('Torta Cookie', 'Torta cookie vegana e sem glúten.', 20.00, 'Docinhos', 0, NULL),
    ('Torta de Limão', 'Fatia de torta de limão', 20.00, 'Docinhos', 0, NULL),
    ('Torta de Morango', 'Torta de morango com massa de pão de ló. A calda pode ser de chocolate ou chantilly.', 20.00, 'Docinhos', 0, NULL),
    ('Torta Folhada de Maçã', 'Torta folhada de maçã com creme de amêndoas, caramelo salgado e sorvete de creme.', 29.00, 'Docinhos', 0, NULL),
    ('Cuscuz temperado', 'Cuscuz temperadinho com um acompanhamento: carne louca (carne desfiada com pimentões coloridos e cebola), queijo coalho ou ovo frito.Versão vegana com cogumelos', 26.00, 'Regionais', 0, NULL),
    ('Sopa do dia', 'Acompanha porção de torradas. Consultar sabor do dia.', 29.00, 'Regionais', 0, NULL),
    ('Tapioca rendada', 'Sabores: carne louca (carne desfiada com pimentões coloridos e cebola) ou coco e queijo coalho ou frango.', 27.00, 'Regionais', 0, NULL),
    ('Omelete', 'Sabores: queijo muçarela com tomate confit - R$ 30,00frango desfiado com requeijão e tomate confit - R$32,00Acompanha saladinha de folhas.', 30.00, 'Ovos e Toasts', 0, NULL),
    ('Ovos com bacon', 'Pão de fermentação natural, ovos com gema mole e fatias de bacon', 23.00, 'Ovos e Toasts', 0, NULL),
    ('Ovos mexidos', 'Dois ovos mexidos com pão de fermentação natural.', 18.00, 'Ovos e Toasts', 0, NULL),
    ('Ovos no Purgatório', 'Ovos moles cozidos no molho de tomate com calabresa. Acompanha pão de fermentação natural.', 26.00, 'Ovos e Toasts', 0, NULL),
    ('Pão na chapa', 'Pão de fermentação natural na chapa', 12.00, 'Ovos e Toasts', 0, NULL),
    ('Toast de Brie e Jamon', 'Pão de fermentação natural, queijo brie, jamon, tomatinho confit e molho pesto', 29.00, 'Ovos e Toasts', 0, NULL),
    ('Toast de frango cremoso', 'Pão de fermentação natural, frango cremoso, rúcula, geleia de maçã e nozes', 28.00, 'Ovos e Toasts', 0, NULL),
    ('Toast de guacamole', 'Pão de fermentação natural, guacamole, ovos moles e jamon serrano.', 29.00, 'Ovos e Toasts', 0, NULL),
    ('Toast Vegana', 'Pão de fermentação natural, homus, queijo de castanha, tomate confit e cogumelos.', 30.00, 'Ovos e Toasts', 0, NULL),
    ('Brie com Parma', 'Sanduíche de brie com parma e geleia de damasco. O pão pode ser ciabatta ou croissant.', 34.00, 'Sanduíches', 0, NULL),
    ('carne louca com queijo e maionese verde', 'sanduíche de carne louca (carne desfiada com pimentões coloridos e cebola), queijo muçarela e maionese verde. Pode ser no ciabatta ou croissant.', 35.00, 'Sanduíches', 0, NULL),
    ('Costelinha de porco', 'Sanduíche de costelinha de porco com requeijão e cebola caramelizada. Acompanha barbecue de goiabada da casa. O pão pode ser ciabatta ou croissant.', 35.00, 'Sanduíches', 0, NULL),
    ('Do Reino', 'Sanduíche de queijo do reino. O pão pode ser ciabatta ou croissant.', 28.00, 'Sanduíches', 0, NULL),
    ('Frango cremoso com bacon', 'Sanduíche de frango cremoso com bacon, rúcula e geleia de tomate. Pode ser no pão ciabatta ou croissant.', 32.00, 'Sanduíches', 0, NULL),
    ('Muçarela crocante', 'Sanduíche de queijo muçarela crocante com requeijão e geleia de tomate. O pão pode ser ciabatta ou croissant.', 29.00, 'Sanduíches', 0, NULL),
    ('Vegano no ciabatta', 'Pão ciabatta com homus, cogumelos, alface, rúcula, tomate confit e queijo de castanha.', 31.00, 'Sanduíches', 0, NULL),
    ('Salada de camarão', 'Mix de folhas, camarão grelhado, manga, cenoura ralada, queijo coalho, tomate cereja e nozes.', 49.00, 'Saladas', 0, NULL),
    ('Salada de frango', 'Mix de folhas com frango desfiado, amêndoas tostadas, tomate confit, frutas secas, molho de mostarda doce. Acompanha torradas.', 42.00, 'Saladas', 0, NULL),
    ('Salada Toast', 'Mix de folhas com tomatinho confit, nozes e toast de homus com geleia de maçã.', 40.00, 'Saladas', 0, NULL),
    ('Camarão ao molho de tomate', 'Camarão com penne ao molho de tomate, molho pesto e parmesão.', 54.00, 'Pratos quentes', 0, NULL);

INSERT INTO prato (nome, descricao, preco, categoria, happy_hour, imagem) VALUES
    ('Frango tarê', 'Filé de peito de frango no molho tarê, com purê de batata doce e espaguete de legumes (cenoura e abobrinha)', 37.00, 'Pratos quentes', 0, NULL),
    ('Parmê de frango', 'Parmegiana de frango com espaguete ao molho de tomate e queijo parmesão', 37.00, 'Pratos quentes', 0, NULL),
    ('Picadinho', 'Picadinho de coxão mole, arroz alho e óleo, farofa panko temperada, banana grelhada e ovo frito', 42.00, 'Pratos quentes', 0, NULL),
    ('Risoto de alho poró', 'Risoto cremoso com mix de arroz arbóreo e 7 grãos com cogumelos, alho poró, queijo parmesão e amêndoas laminadas. Possibilidade de versão vegana com queijo de castanha.', 49.00, 'Pratos quentes', 0, NULL),
    ('Risoto de camarão', 'Risoto de camarão com arroz arbóreo, arroz sete grãos, tomatinhos confit, espaguete de legumes e chips de batata doce', 55.00, 'Pratos quentes', 0, NULL),
    ('Risoto de costelinha de porco', 'Risoto de costelinha de porco com arroz arbóreo, tomatinho confit, molho roti e parmesão', 50.00, 'Pratos quentes', 0, NULL),
    ('Tilápia grelhada', 'File de tilápia grelhada com cebola e alcaparras, espaguete de legumes (cenoura e abobrinha) e arroz de brócolis.', 41.00, 'Pratos quentes', 0, NULL),
    ('Cubinhos de frango com penne', 'Cubinhos de frango salteado com penne, molho de tomate e parmesão.', 28.00, 'Menu Kids', 0, NULL),
    ('Picadinho', 'Picadinho de carne com arroz e purê de batata.', 28.00, 'Menu Kids', 0, NULL),
    ('Manhã na Grama', 'Piquenique Manhã na Grama. Opções para 2 pessoas (R$ 99,00) ou 4 pessoas (R$ 179,00).Mini bolo, sanduíche frio, torradas, geleia, quiche de muçarela com tomate confit, pão de queijo, salada de fruta e suco de fruta.', 99.00, 'Piquenique', 0, NULL),
    ('Cookie Vegano', 'Cookie vegano sem glúten. Sabores tradicional e chocolate.', 15.00, 'Veganos', 0, NULL),
    ('Cuscuz com cogumelos', 'cuscuz temperado com cogumelos shitake e shimeji refogados', 28.00, 'Veganos', 0, NULL),
    ('Risoto de alho poró', 'Risoto cremoso com mix de arroz arbóreo e 7 grãos com cogumelos, alho poró, queijo parmesão e amêndoas laminadas. Possibilidade de versão vegana com queijo de castanha.', 49.00, 'Veganos', 0, NULL),
    ('Salada Toast', 'Mix de folhas com tomatinho confit, nozes e toast de homus com geleia de maçã.', 40.00, 'Veganos', 0, NULL),
    ('Toast Vegana', 'Pão de fermentação natural, homus, queijo de castanha, tomate confit e cogumelos.', 30.00, 'Veganos', 0, NULL),
    ('Torta Cookie', 'Torta cookie vegana e sem glúten.', 20.00, 'Veganos', 0, NULL),
    ('Vegano no ciabatta', 'Pão ciabatta com homus, cogumelos, alface, rúcula, tomate confit e queijo de castanha.', 31.00, 'Veganos', 0, NULL),
    ('Aconchego', 'Café espresso, creme de chocolate branco, canela, leite vaporizado cremoso e chantilly - 150ml', 20.00, 'Espresso e Derivados', 0, NULL),
    ('Capuccino Brasileiro', 'Café espresso, creme de chocolate, canela e leite vaporizado cremoso - 150ml', 19.00, 'Espresso e Derivados', 0, NULL),
    ('Capuccino Italiano', 'Café espresso, cacau e leite vaporizado cremoso - 150ml', 18.00, 'Espresso e Derivados', 0, NULL),
    ('Doppio', 'Café espresso duplo - 80ml', 15.00, 'Espresso e Derivados', 0, NULL),
    ('Espresso', 'Café espresso - 50ml', 9.00, 'Espresso e Derivados', 0, NULL),
    ('Espresso Carioca', 'Café espresso carioca - 80ml', 9.00, 'Espresso e Derivados', 0, NULL),
    ('Flat White', 'Café espresso duplo com leite vaporizado cremoso - 180ml', 18.00, 'Espresso e Derivados', 0, NULL),
    ('Furdunço', 'Café espresso, creme toffee e leite vaporizado cremoso - 180ml', 19.00, 'Espresso e Derivados', 0, NULL),
    ('Latte', 'Café espresso com leite vaporizado cremoso - 180ml', 17.00, 'Espresso e Derivados', 0, NULL),
    ('Macchiato', 'Café espresso com pingado de leite vaporizado cremoso - 80ml', 15.00, 'Espresso e Derivados', 0, NULL),
    ('Mocha', 'Café espresso, chocolate cremoso e leite vaporizado cremoso - 180ml', 19.00, 'Espresso e Derivados', 0, NULL),
    ('Veg Latte', 'Café espresso e leite de aveia vaporizado cremoso - 180ml', 19.00, 'Espresso e Derivados', 0, NULL),
    ('Clever', 'O preparo na clever permite escolher a intensidade do café por ter uma válvula que só libera o fluxo da bebida quando for colocado na xícara - 180mlTemos opção de café descafeinado', 17.00, 'Cafés Filtrados', 0, NULL),
    ('Koar', 'Filtro criado em Pernambuco, que ressalta a doçura e suaviza a acidez, evidenciando o corpo do café, resultando em uma bebida agradável e equilibrada -180mlTemos opção de café descafeinado', 17.00, 'Cafés Filtrados', 0, NULL),
    ('V60', 'Destaca as características naturais do grão com uma filtragem que realça a acidez e a doçura natural do café, resultando em uma bebida leve - 180mlTemos opção de café descafeinado', 17.00, 'Cafés Filtrados', 0, NULL),
    ('Afogatto', 'Sorvete de creme, café espresso e creme toffee - 230ml', 20.00, 'Cafés Gelados', 0, NULL),
    ('Espresso Tônica', 'Café espresso, água tônica e gelo', 17.00, 'Cafés Gelados', 0, NULL),
    ('Espresso Tônica Laranja', 'Café espresso, água tônica, xarope de laranja da casa e gelo - 330ml', 19.00, 'Cafés Gelados', 0, NULL),
    ('Iced Latte', 'café espresso, leite gelado cremoso e gelo - 330ml', 18.00, 'Cafés Gelados', 0, NULL),
    ('Iced Latte Furdunço', 'Café espresso, toffee, leite gelado cremoso e gelo - 330ml', 19.00, 'Cafés Gelados', 0, NULL),
    ('Iced Mocha', 'Café espresso, creme de chocolate, leite gelado cremoso e gelo - 330ml', 19.00, 'Cafés Gelados', 0, NULL),
    ('Veg Latte Iced', 'Café espresso, leite de aveia gelado cremoso e gelo - 330ml', 20.00, 'Cafés Gelados', 0, NULL),
    ('Citrus', 'Café extraído a frio, água com gás, xarope de laranja e espuma de limão - 330ml', 20.00, 'Cold Brew', 0, NULL),
    ('Cold Brew', 'Café extraído a frio, servido com gelo e limão siciliano - 230ml', 17.00, 'Cold Brew', 0, NULL),
    ('Tropical', 'Café extraído a frio, água com gás, xarope de abacaxi e espuma de limão - 330ml', 20.00, 'Cold Brew', 0, NULL),
    ('Frapê', 'Batido com sorvete e leite. Finalizado com chantilly. Sabores: café, doce de leite ou morango.', 22.00, 'Frapês', 0, NULL),
    ('Chocolate Quente', 'Chocolate quente - 150ml', 16.00, 'Diversos', 0, NULL),
    ('Hibisco Refrescante', 'Chá de hibisco, xarope de abacaxi da casa e gelo - 330ml', 18.00, 'Diversos', 0, NULL),
    ('Mate com Limão', 'Chá mate com limão, açúcar e gelo - 330ml', 18.00, 'Diversos', 0, NULL),
    ('O Chá da Casa', 'Equilíbrio - blend de chá preto com especiariasCalma - blend de camomila, tangerina e cravoVibração - capim limão, limão siciliano, maçã e funchoLeveza - hibisco, cranberry, mate verde, uva e maçã180ml', 16.00, 'Diversos', 0, NULL),
    ('Soda Italiana', 'Xarope da casa com aguá com gás e gelo. Sabores xarope: frutas vermelhas, laranja ou maracujá - 330ml', 17.00, 'Diversos', 0, NULL),
    ('Suco de fruta', 'Suco de frutaCopo 330ml - R$ 13,00Jarra 750ml - R$ 24,00Sabores: laranja, morango, limão, acerola, abacaxi, maracujá', 13.00, 'Diversos', 0, NULL),
    ('Aperol Spritz', 'Aperol, água com gás, espumante, gelo e uma rodela de laranja', 28.00, 'Drinks', 0, NULL);

INSERT INTO prato (nome, descricao, preco, categoria, happy_hour, imagem) VALUES
    ('Gin Tonic', 'Gin, água tônica, gelo e xarope da casa (laranja, maracujá ou frutas vermelhas)', 28.00, 'Drinks', 0, NULL),
    ('Mimosa', 'Espumante, suco de laranja e morangos amassados', 25.00, 'Drinks', 0, NULL),
    ('Água com gás', 'Água com gás 330ml', 8.00, 'Bebidas', 0, NULL),
    ('Água sem gás', 'Água sem gás 330ml', 7.00, 'Bebidas', 0, NULL),
    ('Cerveja Heineken', 'Longneck', 15.00, 'Bebidas', 0, NULL),
    ('Cerveja Heineken Zero', 'Longneck', 15.00, 'Bebidas', 0, NULL),
    ('Cerveja Stella Artois', '600ml', 18.00, 'Bebidas', 0, NULL),
    ('Coca cola lata 350ml', 'Coca cola lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Coca cola zero lata 350ml', 'Coca cola zero lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Fanta lata 350ml', 'Fanta lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Guaraná Antarctica lata 350ml', 'Guaraná Antarctica lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Guaraná Antarctica zero lata 350ml', 'Guaraná Antarctica zero lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Licor', 'Licor - consultar sabor disponível', 20.00, 'Bebidas', 0, NULL),
    ('Sprite lata 350ml', 'Sprite lata 350ml', 9.00, 'Bebidas', 0, NULL),
    ('Alto Tierruca Reserva Carmenere', 'Colchagua - Chile', 99.00, 'Vinhos', 0, NULL),
    ('Alto Tierruca Reserva Sauvignon Blanc', 'Curicó - Chile', 99.00, 'Vinhos', 0, NULL),
    ('Amayan Belhara Reserva Chardonnay', 'Mendoza - Argentina', 99.00, 'Vinhos', 0, NULL),
    ('Amayan Belhara Reserva Malbec', 'Mendoza - Argentina', 99.00, 'Vinhos', 0, NULL),
    ('Casa de Cambres Doc Douro Reserva Branco', 'Douro - Portugal', 105.00, 'Vinhos', 0, NULL),
    ('Espumante Virtus Monte Paschoal Brut', 'Vale dos Vinhedos - Brasil', 95.00, 'Vinhos', 0, NULL),
    ('Perez Cruz Reserva Cabernet Sauvignon', 'Maipo - Chile', 109.00, 'Vinhos', 0, NULL),
    ('Taça vinho branco', '', 19.00, 'Vinhos', 0, NULL),
    ('Taça vinho tinto', '', 19.00, 'Vinhos', 0, NULL),
    ('Acompanhamentos e porções', 'PROTEÍNAS - R$14,00(carne louca, frango desfiado, costelinha de porco desfiada)ACOMPANHAMENTOS - R$ 12,00(salada de folhas, arroz, purê de batata ou batata doce, espaguete de legumes, farofa)PORÇÕES - R$ 7,00(queijo parmesão, requeijão, geleia, granola, mel de abelha, molho pesto, mostarda doce)EXTRAS - R$ 10,00(ovos, bacon, queijo coalho)', 14.00, 'Acompanhamentos e porções', 0, NULL),
    ('Bolo do dia', 'Fatia de bolo. Consultar o sabor do dia.', 14.00, 'Happy Hour', 1, NULL);

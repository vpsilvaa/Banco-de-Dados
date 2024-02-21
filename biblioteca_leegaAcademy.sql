CREATE DATABASE biblioteca;

USE biblioteca;

CREATE TABLE IF NOT EXISTS Usuario (
    id_usuario INT auto_increment PRIMARY KEY,
    nm_usuario VARCHAR(100) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    telefone NUMERIC(12) NOT NULL,
    CEP NUMERIC(20) NOT NULL,
    CPF NUMERIC(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Editora (
    id_editora INT auto_increment PRIMARY KEY,
    nm_editora VARCHAR(100) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    cidade VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS Autor (
    id_autor INT auto_increment PRIMARY KEY,
    nm_autor VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Cargo (
    id_cargo INT auto_increment PRIMARY KEY,
    nm_cargo VARCHAR(100) NOT NULL,
    salario INT NOT NULL
);

CREATE TABLE IF NOT EXISTS Obra (
    id_obra INT auto_increment PRIMARY KEY,
    id_editora INT NOT NULL, -- FK referenciando a tabela Editora
    id_autor INT NOT NULL, -- FK referenciando a tabela Autor
    titulo_obra VARCHAR(100) NOT NULL,
    num_publi INT NOT NULL,
    genero VARCHAR(20) NOT NULL,
    dt_publi DATE NOT NULL,
    FOREIGN KEY (id_editora) REFERENCES Editora(id_editora),
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

CREATE TABLE IF NOT EXISTS Departamento (
    id_dept INT,
    id_cargo INT, -- FK referenciando a tabela Cargo
    nm_dept VARCHAR(100) NOT NULL,
    PRIMARY KEY(id_dept, id_cargo),
    FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo)
);

CREATE TABLE IF NOT EXISTS Funcionario (
    id_func INT auto_increment PRIMARY KEY,
    id_cargo INT NOT NULL, -- FK referenciando a tabela Cargo
    id_dept INT NOT NULL, -- FK referenciando a tabela Departamento
    nm_func VARCHAR(100) NOT NULL,
    dt_admissao DATE NOT NULL,
    dt_demissao DATE NOT NULL,
    FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo),
    FOREIGN KEY (id_dept) REFERENCES Departamento(id_dept)
);

CREATE TABLE IF NOT EXISTS Estoque (
    id_estoque INT,
    id_obra INT, -- FK referenciando a tabela Obra
    qtd_livro INT NOT NULL,
    vlr_unitario INT NOT NULL,
    PRIMARY KEY(id_estoque, id_obra),
    FOREIGN KEY (id_obra) REFERENCES Obra(id_obra)
);

CREATE TABLE IF NOT EXISTS Emprestimo (
    id_emprestimo INT auto_increment,
    id_func INT, -- FK referenciando a tabela Funcionario
    id_usuario INT, -- FK referenciando a tabela Usuario
    id_estoque INT, -- FK referenciando a tabela Estoque
    id_obra INT, -- FK referenciando a tabela Obra
    dt_emprestimo DATE NOT NULL,
    hr_emprestimo DATE NOT NULL,
    dt_entrega DATE NOT NULL,
    PRIMARY KEY(id_emprestimo, id_func, id_usuario, 
				id_estoque, id_obra),
    FOREIGN KEY (id_func) REFERENCES Funcionario(id_func),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque),
    FOREIGN KEY (id_obra) REFERENCES Obra(id_obra)
);

CREATE TABLE IF NOT EXISTS Devolucao (
    id_devolucao INT auto_increment,
    id_func INT, -- FK referenciando a tabela Funcionario
    id_emprestimo INT, -- FK referenciando a tabela Emprestimo
    id_estoque INT, -- FK referenciando a tabela Estoque
    id_usuario INT, -- FK referenciando a tabela Usuario
    id_obra INT, -- FK referenciando a tabela Obra
    dt_devolucao DATE NOT NULL,
    hr_devolucao DATE NOT NULL,
    mlt_atraso VARCHAR(2) NOT NULL,
    PRIMARY KEY(id_devolucao, id_func, id_emprestimo, 
				id_estoque, id_usuario, id_obra),
    FOREIGN KEY (id_func) REFERENCES Funcionario(id_func),
    FOREIGN KEY (id_emprestimo) REFERENCES Emprestimo(id_emprestimo),
    FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_obra) REFERENCES Obra(id_obra)
);

CREATE TABLE Reserva (
    id_reserva INT auto_increment,
    id_emprestimo INT, -- FK referenciando a tabela Emprestimo
    id_func INT, -- FK referenciando a tabela Funcionario
    id_estoque INT, -- FK referenciando a tabela Estoque
    id_usuario INT, -- FK referenciando a tabela Usuario
    id_obra INT, -- FK referenciando a tabela Obra
    sts_livro VARCHAR(100) NOT NULL,
    dt_reserva DATE NOT NULL,
    hr_reserva DATE NOT NULL,
    PRIMARY KEY(id_reserva, id_emprestimo, id_func, 
				id_estoque, id_usuario, id_obra),
    FOREIGN KEY (id_emprestimo) REFERENCES Emprestimo(id_emprestimo),
    FOREIGN KEY (id_func) REFERENCES Funcionario(id_func),
    FOREIGN KEY (id_estoque) REFERENCES Estoque(id_estoque),
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    FOREIGN KEY (id_obra) REFERENCES Obra(id_obra)
);

ALTER TABLE Usuario
MODIFY COLUMN CPF VARCHAR(40) NOT NULL;

ALTER TABLE Usuario
ADD CONSTRAINT CPF UNIQUE (CPF);

ALTER TABLE Estoque
MODIFY COLUMN vlr_unitario DECIMAL(10,2) NOT NULL;

ALTER TABLE Cargo
MODIFY COLUMN salario DECIMAL(10,2) NOT NULL;

ALTER TABLE Usuario
MODIFY COLUMN telefone VARCHAR(30) NOT NULL;

ALTER TABLE Usuario
MODIFY COLUMN CEP VARCHAR(40) NOT NULL;

ALTER TABLE Emprestimo
MODIFY COLUMN hr_emprestimo TIME NOT NULL;

ALTER TABLE Devolucao
MODIFY COLUMN hr_devolucao TIME NOT NULL;

ALTER TABLE Reserva
MODIFY COLUMN hr_reserva TIME NOT NULL;

CREATE TABLE IF NOT EXISTS tel_usuario (
    id_usuario INT NOT NULL,
    telefone VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

ALTER TABLE Usuario
DROP COLUMN telefone;

CREATE TABLE IF NOT EXISTS end_usuario (
    id_usuario INT NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    CEP VARCHAR(40) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

ALTER TABLE Usuario
DROP COLUMN logradouro,
DROP COLUMN bairro,
DROP COLUMN CEP;

CREATE TABLE IF NOT EXISTS Genero (
    id_genero INT auto_increment PRIMARY KEY,
    nm_genero VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Genero_Obra (
    id_genero INT,
    id_obra INT,
    PRIMARY KEY(id_genero, id_obra),
	FOREIGN KEY (id_genero) REFERENCES Genero(id_genero),
	FOREIGN KEY  (id_obra) REFERENCES Obra(id_obra)
);


ALTER TABLE Obra
DROP COLUMN genero;

CREATE TABLE IF NOT EXISTS Autor_Obra (
    id_autor INT,
    id_obra INT,
    PRIMARY KEY(id_autor, id_obra),
	FOREIGN KEY (id_autor) REFERENCES Autor(id_autor),
	FOREIGN KEY  (id_obra) REFERENCES Obra(id_obra)
);

ALTER TABLE obra DROP FOREIGN KEY obra_ibfk_2;
ALTER TABLE Obra
DROP COLUMN id_autor;

SET SQL_SAFE_UPDATES = 0;

INSERT INTO usuario (id_usuario, nm_usuario, cpf)
VALUES
("1", "Antonio Marcos da Silva", "193.107.214-21"),
("2", "Carlos Drummond de Andrade", "122.147.655-47"),
("3", "Juliana Bento Souza", "193.107.214-22"),
("4", "Arlene Batista", "122.147.655-48"),
("5", "Bret Berlusconi", "193.107.214-23"),
("6", "Cindy Crall", "122.147.655-49"),
("7", "Donatelo Siqueira", "193.107.214-24"),
("8", "Emily Mall", "122.147.655-50"),
("9", "Franklin Pekens", "193.107.214-25"),
("10", "Gert Hender", "122.147.655-51"),
("11", "Harvey Jonks", "193.107.214-26"),
("12", "Irene Silva", "122.147.655-52"),
("13", "Jose Albino", "193.107.214-27"),
("14", "Katia Suellen", "122.147.655-53"),
("15", "Lee Shimizu", "193.107.214-28"),
("16", "Maria Aparecida", "122.147.655-54"),
("17", "Nate Rogan", "193.107.214-29"),
("18", "Ophelia Maria", "122.147.655-55"),
("19", "Philippe Coutinho", "193.107.214-30"),
("20", "Rina Pontes", "122.147.655-56"),
("21", "Sean Woods", "193.107.214-31"),
("22", "Tammy Miranda", "122.147.655-57"),
("23", "Vicente Del Bosque", "193.107.214-32"),
("24", "Whitney Cinse", "122.147.655-58"),
("25", "Alberto Roberto", "193.107.214-33"),
("26", "Beryl Berey", "122.147.655-59"),
("27", "Chris Nicolas", "193.107.214-34"),
("28", "Debby Loyd", "122.147.655-60"),
("29", "Ernesto Coimbra", "193.107.214-35"),
("30", "Florence Seedorf", "122.147.655-61");

INSERT INTO end_usuario (id_usuario, logradouro, bairro, cep)
VALUES
("1", "Avenida 23 de Maio 21", "Jardim das Árvores", "05728-354"),
("2", "Rua Martins Fontes 252", "Parque Industrial", "02182-635"),
("3", "Avenida dos Bandeirantes 20", "Residencial Dourados", "05728-355"),
("4", "Avenida Eng. Luis Carlos Berrini 12", "Vila Água Bonita", "02182-636"),
("5", "Rua da Consolação 14", "Vila Brasil", "05728-356"),
("6", "Rua Ipiranga 123", "Vila Cristal", "02182-637"),
("7", "Avenida Brigadeiro Faria Lima 50", "Vila das Árvores", "05728-357"),
("8", "Rua Funchal 1000", "Vila das Nações", "02182-638"),
("9", "Avenida Ibirapuera 300", "Vila do Lago", "05728-358"),
("10","Avenida Interlagos 247", "Vila dos Estados", "02182-639"),
("11", "Avenida José Carlos Pace 23", "Vila dos Pássaros", "05728-359"),
("12", "Avenida Pres. Juscelino Kubitschek 45", "Vila Dourados", "02182-640"),
("13", "Avenida Brigadeiro Luis Antonio 48", "Água Aguinha", "05728-360"),
("14", "Marginal Pinheiros 69", "Água Bonita", "02182-641"),
("15", "Avenida Nossa Sra. do Sabará 65", "Conceição", "05728-361"),
("16", "Avenida Nove de Julho 72", "Conjunto Metalúrgicos", "02182-642"),
("17", "Rua Olimpíadas 68", "Continental", "05728-362"),
("18", "Avenida Rebouças 2581", "Distrito Industrial Altino", "02182-643"),
("19", "Avenida do Rio Bonito 2541", "Distrito Industrial Anhanguera", "05728-363"),
("20", "Avenida Robert Kennedy 3965", "Distrito Industrial Autonomistas", "02182-644"),
("21", "Avenida Jornalista Roberto Marinho 698", "Distrito Industrial Centro", "05728-364"),
("22", "Avenida Santo Amaro 5879", "Distrito Industrial Mazzei", "02182-645"),
("23", "Rua Maria Imaculada 6598", "Distrito Industrial Remédios", "05728-365"),
("24", "Avenida Washington Luis 654747", "Helena Maria", "02182-646"),
("25", "Avenida Alfredo Maia 584", "IAPI", "05728-366"),
("26", "Avenida Alfredo Maluf 265", "Jaguaribe", "02182-647"),
("27", "Avenida Alfredo Pujol 987", "Jardim D'Abril", "05728-367"),
("28", "Avenida Amazonas 574", "Jardim das Flores", "02182-648"),
("29", "Avenida Ampére 414", "Jardim Elvira", "05728-368"),
("30", "Avenida Ana Camargo 174", "Jardim Mutinga", "02182-649");


UPDATE usuario
SET nm_usuario = TRIM(BOTH ' ' FROM nm_usuario);

INSERT INTO editora (id_editora, nm_editora, logradouro, cidade)
VALUES
("1", "Aleph", "Rua Funchal 1000", "São Paulo"),
("2", "Moderna", "Avenida Ibirapuera 300", "Campinas"),
("3", "Saraiva", "Avenida Interlagos 247", "Barretos"),
("4", "Ática", "Avenida José Carlos Pace 23", "Boituva"),
("5", "Casa", "Avenida Pres. Juscelino Kubitschek 45", "Marabá"),
("6", "Leya", "Avenida Brigadeiro Luis Antonio 48", "Ibiuna"),
("7", "Draco", "Marginal Pinheiros 69", "São José"),
("8", "Nova", "Avenida Nossa Sra. do Sabará 65", "São Paulo");


ALTER TABLE editora ADD COLUMN rua VARCHAR(100);
ALTER TABLE editora ADD COLUMN numero INT;

UPDATE editora
SET numero = CAST(SUBSTRING_INDEX(logradouro, ' ', -1) AS UNSIGNED),
    rua = TRIM(SUBSTRING_INDEX(logradouro, CAST(SUBSTRING_INDEX(logradouro, ' ', -1) AS CHAR), 1));

ALTER TABLE editora 
DROP COLUMN logradouro;

ALTER TABLE end_usuario ADD COLUMN rua VARCHAR(100);
ALTER TABLE end_usuario ADD COLUMN numero INT;

UPDATE end_usuario
SET numero = CAST(SUBSTRING_INDEX(logradouro, ' ', -1) AS UNSIGNED),
    rua = TRIM(SUBSTRING_INDEX(logradouro, CAST(SUBSTRING_INDEX(logradouro, ' ', -1) AS CHAR), 1));

ALTER TABLE end_usuario
DROP COLUMN logradouro;

INSERT INTO autor (id_autor, nm_autor)
VALUES
("1", "Alberto Mussa"),
("2", "Aluísio de Azevedo"),
("3", "Ariano Suassuna"),
("4", "Autran Dourado"),
("5", "Bernardo Guimarães"),
("6", "Casimiro de Abreu"),
("7", "Carlos Heitor Cony"),
("8", "Clarice Lispector"),
("9", "Denis Mandarino"),
("10", "George Raymond Richard Martin"),
("11", "John Ronald Reuel Tolkien"),
("12", "Clive Staples Lewis"),
("13", "Edgar Allan Poe"),
("14", "Rick Riordan"),
("15", "Alexandre Dumas");

INSERT INTO cargo (id_cargo, nm_cargo, salario)
VALUES
("1", "Diretor", "20000"),
("2", "Gerente", "8000"),
("3", "Coordenador de Finanças", "7000"),
("4", "Coordenador Contabil", "7000"),
("5", "Coordenador de RH", "6000"),
("6", "Coordenador de TI", "7000"),
("7", "Analista de Sistemas", "3000"),
("8", "Analista de Suporte", "2500"),
("9", "Auxiliar Financeiro", "1700"),
("10", "Auxiliar Contábil", "1700"),
("11", "Auxiliar de RH", "1300"),
("12", "Recepcionista", "1000");

INSERT INTO departamento (id_dept, id_cargo, nm_dept)
VALUES
("1", "1", "Diretoria"),
("2", "2", "Gerência"),
("3", "3", "Financeiro"),
("4", "4", "Contábil"),
("5", "6", "TI"),
("6", "5", "Recursos Humanos"),
("7", "12", "Recepção");

INSERT INTO obra (id_obra, id_editora, titulo_obra, num_publi, dt_publi)
VALUES
("1", "1", "O Conde de Monte Cristo", "12", "2005-05-10"),
("2", "2", "Tratado de Confissom", "5", "2010-12-31"),
("3", "5", "Triste Fim de Policarpo Quaresm", "3", "2001-03-05"),
("4", "8", "Tratado da Natureza Humana", "78", "2002-05-14"),
("5", "7", "Farsa de Inês Pereira ", "2", "1986-04-25"),
("6", "6", "Filho Nativo", "45", "2004-06-12"),
("7", "6", "Jogo Dos Tronos", "6", "2001-08-26"),
("8", "8", "Diabo dos Números", "2", "1981-08-31"),
("9", "6", "Furia dos Reis", "1", "2008-08-06"),
("10", "6", "Filhos e Amantes", "98", "2005-09-01"),
("11", "5", "Finis Patriae ", "46", "2013-03-04"),
("12", "5", "Finnegans Wake ", "2", "2013-09-30"),
("13", "1", "Os Três Mosqueteiros", "2", "1953-03-06"),
("14", "3", "Falcão de Malta", "2", "2010-01-02"),
("15", "2", "Vidas Secas", "45", "2004-07-09"),
("16", "4", "Flores sem Fruto ", "1", "2001-08-15"),
("17", "7", "Deixados para Trás", "8", "1931-09-12"),
("18", "8", "Deus das Moscas", "2", "2003-09-25"),
("19", "4", "Senhor dos Aneis", "4", "1989-02-28"),
("20", "3", "Fluviais ", "8", "2011-03-18"),
("21", "2", "Folhas Caídas ", "1", "2010-09-19"),
("22", "6", "Força das Coisas", "24", "1985-11-25"),
("23", "5", "Fortaleza de Sharpe", "81", "2001-01-01"),
("24", "1", "Frankenstein ", "8", "2010-12-13"),
("25", "7", "Rei Arthur", "85", "1999-07-15"),
("26", "6", "Dom Casmurro", "2", "2011-08-15"),
("27", "4", "Dia dos Gafanhotos", "85", "2011-11-11"),
("28", "8", "Diabo dos Números", "2", "2013-05-06"),
("29", "2", "Discurso do Método", "8", "2012-08-06"),
("30", "3", "Arte Da Guerra", "8", "1913-05-01");

UPDATE obra
SET titulo_obra = TRIM(BOTH ' ' FROM titulo_obra);

INSERT INTO genero (id_genero, nm_genero)
VALUES
("1", "Auto Ajuda"),
("2", "Filosofia"),
("3", "Política"),
("4", "Romance"),
("5", "Religioso"),
("6", "Poema"),
("7", "Ficção"),
("8", "Terror"),
("9", "Estrangeiro"),
("10", "Infanto Juvenil");

INSERT INTO tel_usuario (id_usuario, telefone)
VALUES
("1", "5844-2647"),
("2", "5846-6576"),
("3", "5879-5469"),
("4", "1254-5647"),
("5", "5844-2648"),
("6", "5846-6577"),
("7", "5879-5470"),
("8", "1254-5648"),
("9", "5844-2649"),
("10", "5846-6578"),
("11", "5879-5471"),
("12", "1254-5649"),
("13", "5844-2650"),
("14", "5846-6579"),
("15", "5879-5472"),
("16", "1254-5650"),
("17", "5844-2651"),
("18", "5846-6580"),
("19", "5879-5473"),
("20", "1254-5651"),
("21", "5844-2652"),
("22", "5846-6581"),
("23", "5879-5474"),
("24", "1254-5652"),
("25", "5844-2653"),
("26", "5846-6582"),
("27", "5879-5475"),
("28", "1254-5653"),
("29", "5844-2654"),
("30", "5846-6583");

INSERT INTO estoque (id_estoque, id_obra, qtd_livro, vlr_unitario)
VALUES
("1.0", "23.0", "17.0", "122.5"),
("2.0", "2.0", "12.0", "55.0"),
("3.0", "25.0", "17.0", "80.0"),
("4.0", "1.0", "5.0", "90.0"),
("5.0", "24.0", "64.0", "105.0"),
("6.0", "3.0", "4.0", "20.0"),
("7.0", "21.0", "10.0", "55.0"),
("8.0", "28.0", "7.0", "101.0"),
("9.0", "12.0", "6.0", "115.85"),
("10.0", "30.0", "16.0", "90.36"),
("11.0", "18.0", "9.0", "85.37"),
("12.0", "29.0", "3.0", "82.12"),
("13.0", "13.0", "19.0", "86.54"),
("14.0", "14.0", "7.0", "97.21"),
("15.0", "19.0", "15.0", "60.5"),
("16.0", "4.0", "4.0", "64.32"),
("17.0", "5.0", "23.0", "97.35"),
("18.0", "6.0", "13.0", "98.65"),
("19.0", "20.0", "9.0", "94.2"),
("20.0", "22.0", "15.0", "85.0"),
("21.0", "10.0", "4.0", "87.1"),
("22.0", "11.0", "15.0", "106.84"),
("23.0", "26.0", "25.0", "108.25"),
("24.0", "27.0", "2.0", "57.85"),
("25.0", "7.0", "33.0", "41.63"),
("26.0", "8.0", "6.0", "65.48"),
("27.0", "9.0", "15.0", "53.25"),
("28.0", "15.0", "26.0", "37.15"),
("29.0", "16.0", "16.0", "21.45"),
("30.0", "17.0", "25.0", "25.35");

INSERT INTO funcionario (id_func, id_cargo, id_dept, nm_func, dt_admissao, dt_demissao)
VALUES
("1", "12", "7", "Fabriola Pereira", "2010-01-10", "2022-09-20 00:00:00"),
("2", "2", "2", "Carlos Meireles", "2005-04-11", "9999-01-01 00:00:00"),
("3", "1", "1", "Adalberto Cristovão", "2000-07-11", "9999-01-01 00:00:00"),
("4", "1", "1", "Camilla Prado", "2000-10-10", "9999-01-01 00:00:00"),
("5", "2", "2", "Marcio Tales de Souza", "2001-01-09", "9999-01-01 00:00:00"),
("6", "6", "5", "Fernando da Silva", "2000-04-10", "9999-01-01 00:00:00"),
("7", "3", "3", "Barbara Maria", "2000-07-11", "9999-01-01 00:00:00"),
("8", "12", "7", "Alice Meire ", "2000-10-10", "9999-01-01 00:00:00"),
("9", "5", "6", "João Da Silva", "1999-01-09", "9999-01-01 00:00:00"),
("10", "4", "4", "Marcos Prado", "1997-04-10", "9999-01-01 00:00:00"),
("11", "12", "7", "Claudia Cristina", "2012-10-10", "9999-01-01 00:00:00");

UPDATE funcionario
SET nm_func = TRIM(BOTH ' ' FROM nm_func);

INSERT INTO emprestimo (id_emprestimo, id_func, id_usuario, id_estoque, id_obra, dt_emprestimo, hr_emprestimo, dt_entrega)
VALUES
("1", "1", "1", "21", "10", "2021-08-15", "08:00:00", "2021-08-17"),
("2", "8", "20", "14", "14", "2021-09-26", "08:00:00", "2021-09-28"),
("3", "8", "13", "11", "18", "2021-07-11", "10:00:00", "2021-07-13"),
("4", "8", "29", "30", "17", "2021-08-18", "18:10:00", "2021-08-20"),
("5", "1", "2", "1", "23", "2021-06-09", "08:00:00", "2021-06-11"),
("6", "8", "21", "5", "24", "2021-08-20", "08:00:00", "2021-08-22"),
("7", "1", "14", "7", "21", "2022-03-25", "08:00:00", "2022-03-27"),
("8", "8", "30", "18", "6", "2021-08-19", "13:00:00", "2021-08-21"),
("9", "8", "19", "10", "30", "2022-03-27", "13:00:00", "2022-03-29"),
("10", "1", "3", "27", "9", "2021-08-19", "09:54:00", "2021-08-21"),
("11", "8", "12", "22", "11", "2022-03-29", "13:00:00", "2022-03-31"),
("12", "1", "8", "3", "25", "2021-08-19", "09:54:00", "2021-08-21"),
("13", "1", "11", "29", "16", "2022-03-31", "14:55:00", "2022-04-02"),
("14", "1", "4", "4", "1", "2022-04-01", "12:01:00", "2022-04-03"),
("15", "8", "11", "23", "26", "2023-06-25", "14:29:00", "2023-06-27"),
("16", "1", "22", "13", "13", "2021-08-20", "10:00:00", "2021-08-22"),
("17", "1", "8", "15", "19", "2021-08-20", "14:55:00", "2021-08-22"),
("18", "11", "10", "16", "4", "2023-07-07", "16:30:00", "2023-07-09"),
("19", "8", "12", "24", "27", "2023-07-07", "11:11:00", "2023-07-09"),
("20", "11", "5", "2", "2", "2023-06-25", "17:54:00", "2023-06-27"),
("21", "8", "18", "19", "20", "2022-12-28", "10:00:00", "2022-12-30"),
("22", "8", "15", "20", "22", "2023-06-25", "08:36:00", "2023-06-27"),
("23", "8", "9", "25", "7", "2022-12-28", "14:55:00", "2022-12-30"),
("24", "11", "17", "9", "12", "2022-12-28", "13:00:00", "2022-12-30"),
("25", "8", "6", "17", "5", "2023-07-07", "10:00:00", "2023-07-09"),
("26", "8", "23", "26", "8", "2023-07-07", "18:10:00", "2023-07-09"),
("27", "11", "16", "8", "27", "2023-01-31", "14:55:00", "2023-02-02"),
("28", "11", "7", "12", "29", "2023-01-31", "10:00:00", "2023-02-02"),
("29", "11", "24", "6", "3", "2023-01-31", "18:10:00", "2023-02-02");

INSERT INTO devolucao (id_devolucao, id_func, id_emprestimo, id_usuario, id_estoque, id_obra, dt_devolucao, hr_devolucao, mlt_atraso)
VALUES
("13", "8", "9", "19", "10", "5", "2022-03-29", "08:36:00", "0"),
("5", "8", "8", "30", "18", "16", "2021-08-21", "10:00:00", "0"),
("16", "1", "14", "4", "4", "1", "2022-04-03", "10:00:00", "0"),
("4", "8", "4", "29", "30", "20", "2021-08-20", "12:01:00", "0"),
("2", "8", "3", "13", "11", "3", "2021-07-13", "13:00:00", "0"),
("7", "1", "12", "8", "3", "25", "2021-08-21", "13:00:00", "0"),
("11", "8", "2", "20", "14", "14", "2021-09-28", "14:29:00", "0"),
("3", "1", "1", "1", "21", "14", "2021-08-17", "14:55:00", "0"),
("6", "1", "10", "3", "27", "8", "2021-08-21", "14:55:00", "0"),
("8", "8", "6", "21", "5", "24", "2021-08-22", "14:55:00", "0"),
("19", "11", "24", "17", "9", "12", "2022-12-30", "16:00:00", "0"),
("14", "8", "11", "12", "22", "27", "2022-03-31", "16:30:00", "0"),
("1", "1", "5", "2", "1", "14", "2021-06-11", "18:00:00", "0"),
("10", "1", "17", "8", "15", "22", "2021-08-22", "18:00:00", "0"),
("17", "8", "21", "18", "19", "25", "2022-12-30", "18:00:00", "0"),
("20", "11", "27", "16", "8", "27", "2023-02-02", "18:00:00", "0"),
("9", "1", "16", "22", "13", "13", "2021-08-26", "10:00:00", "1"),
("15", "1", "13", "11", "29", "8", "2022-04-08", "11:11:00", "1"),
("18", "8", "23", "9", "25", "11", "2023-01-12", "15:00:00", "1"),
("12", "1", "7", "14", "7", "27", "2022-03-30", "17:54:00", "1");

INSERT INTO reserva (id_reserva, id_emprestimo, id_func, id_usuario, id_estoque, id_obra, sts_livro, dt_reserva, hr_reserva)
VALUES
("1", "5", "1", "2", "1", "14", "Disponível", "2021-06-08", "08:40:00"),
("2", "3", "8", "13", "11", "3", "Reservado", "2021-07-11", "09:30:00"),
("8", "6", "8", "21", "5", "24", "Disponível", "2021-08-08", "08:15:00"),
("3", "1", "1", "1", "21", "14", "Reservado", "2021-08-14", "08:00:00"),
("10", "17", "1", "8", "15", "22", "Reservado", "2021-08-15", "14:00:00"),
("6", "10", "1", "3", "27", "8", "Reservado", "2021-08-18", "15:00:00"),
("9", "16", "1", "22", "13", "13", "Disponível", "2021-08-18", "18:00:00"),
("4", "4", "8", "29", "30", "20", "Reservado", "2021-08-18", "15:00:00"),
("5", "8", "8", "30", "18", "16", "Reservado", "2021-08-19", "10:00:00"),
("7", "12", "1", "8", "3", "25", "Disponível", "2021-08-19", "09:00:00");

INSERT INTO autor_obra (id_autor, id_obra)
VALUES
("15", "1"),
("12", "2"),
("10", "3"),
("14", "4"),
("8", "5"),
("15", "6"),
("10", "7"),
("13", "8"),
("10", "9"),
("1", "10"),
("3", "11"),
("3", "12"),
("15", "13"),
("6", "14"),
("14", "15"),
("2", "16"),
("4", "17"),
("12", "18"),
("11", "19"),
("7", "20"),
("2", "21"),
("5", "22"),
("15", "23"),
("9", "24"),
("11", "25"),
("6", "26"),
("8", "27"),
("12", "28"),
("3", "29"),
("10", "30");

INSERT INTO genero_obra (id_obra, id_genero)
VALUES
("1", "1"),
("2", "2"),
("3", "3"),
("4", "4"),
("5", "5"),
("6", "6"),
("7", "7"),
("8", "8"),
("9", "9"),
("10", "10"),
("11", "3"),
("12", "4"),
("13", "4"),
("14", "1"),
("15", "2"),
("16", "3"),
("17", "3"),
("18", "4"),
("19", "7"),
("20", "8"),
("21", "7"),
("22", "8"),
("23", "3"),
("24", "4"),
("25", "5"),
("26", "6"),
("27", "3"),
("28", "4"),
("29", "5"),
("30", "4");

-- 1. A Diretora Camilla Prado solicitou uma pesquisa que informe todas as obras
-- cadastradas no acervo ordenadas por data de publicação.

SELECT
titulo_obra AS titulo_obra,
dt_publi AS data_publicacao
FROM obra
ORDER BY dt_publi;

-- 2. O Governador vai doar duzentos livros para a Biblioteca, mas só irá doar se
-- a biblioteca tiver menos de 300 obras. O Gerente Márcio Tales solicitou que fosse feita
-- a contagem de quantas obrasa Biblioteca possui atualmente.

SELECT
sum(qtd_livro) AS quanatidade_obras
FROM
estoque;

-- 3. A Gerência solicitou uma pesquisa para saber quais datas ocorreram
-- empréstimos de livros e a quantidade emprestada. A consulta deverá retornar apenas
-- um registro para cada data

SELECT dt_emprestimo, COUNT(*) as quantidade_emprestada
FROM emprestimo
GROUP BY dt_emprestimo;

-- 4. O Funcionário João Paulo Assistente de RH solicitou uma pesquisa que informasse
-- todos os empréstimos que a Recepcionista Alice Meire fez no horário das 8hs às 9h

SELECT e.id_emprestimo,f.nm_func,e.hr_emprestimo
FROM emprestimo AS e
INNER JOIN funcionario AS f ON f.id_func = e.id_func
WHERE f.nm_func = 'Alice Meire' AND e.hr_emprestimo BETWEEN '08:00:00' AND '
09:00:00';

-- 5. A Gerência solicitou uma pesquisa para saber quais reservas de livros que
-- foram feitas com data maior ou igual a 18/08/2021 que ainda possuem o status de
-- “reservado”.

SELECT obra.titulo_obra, reserva.dt_reserva AS data_reserva,
reserva.sts_livro AS status_livro
FROM reserva
INNER JOIN obra ON reserva.id_obra = obra.id_obra
WHERE reserva.dt_reserva >= '2021-08-18'
AND reserva.sts_livro = 'reservado';

-- 6. A área de RH solicitou uma pesquisa para saber quais devoluções de livros
-- foram feitas antes de 29/03/2022.

SELECT
d.id_devolucao,
d.dt_devolucao AS data_devolucao,
o.titulo_obra
FROM devolucao d
LEFT JOIN
obra o ON d.id_obra = o.id_obra
WHERE d.dt_devolucao < '2022-03-29';

-- 7. O Funcionário João Paulo solicitou uma pesquisa para saber quantas obras
-- do gênero ‘Ficção’ existem no acervo.

SELECT
count(id_obra) AS quantidade_obras
FROM
genero g
INNER JOIN
genero_obra go on g.id_genero = go.id_genero
WHERE
nm_genero = "Ficção";

-- 8. A Diretoria solicitou uma pesquisa para identificar qual o livro possuiu a
-- maior quantidade em estoque, incluir respectiva editora e o respectivo autor.

SELECT
o.id_obra,
o.titulo_obra,
e.nm_editora,
a.nm_autor,
MAX(est.qtd_livro) AS max_qtd_livro
FROM
obra o
JOIN
estoque est ON o.id_obra = est.id_obra
JOIN
editora e ON o.id_editora = e.id_editora
JOIN
autor_obra rel ON o.id_obra = rel.id_obra
JOIN
autor a ON rel.id_autor = a.id_autor
GROUP BY
o.id_obra, o.titulo_obra, e.nm_editora, a.nm_autor
ORDER BY
max_qtd_livro DESC
LIMIT 1;

-- 9. O Financeiro precisa saber qual é o livro que possui a menor quantidade em
-- estoque e quantas vezes ele foi emprestado para que seja feita uma análise para
-- compra de mais alguns exemplares. A área de RH precisa identificar a quantidade
-- total dos empréstimos feitos por cada funcionário ativos.

SELECT o.titulo_obra,MIN(e.qtd_livro) AS quantidade_minima,
COUNT(em.id_emprestimo) as qtd_emprestado
FROM estoque as e
INNER JOIN emprestimo as em ON e.id_estoque = em.id_estoque
INNER JOIN obra as o on o.id_obra = e.id_obra
GROUP BY o.titulo_obra
ORDER BY quantidade_minima
LIMIT 1; -- o limit traz apenas a primeira linha da tabela
SELECT count(e.id_emprestimo) AS qtd_emprestimo, f.nm_func,
CASE WHEN f.dt_demissao = '9999-01-01' THEN 'Ativo' -- caso a dt_demissao for 9999-01-01 seta ativo se n inativo
ELSE 'Inativo' END AS status
FROM emprestimo AS e
INNER JOIN funcionario AS f on f.id_func = e.id_func
WHERE f.dt_demissao = '9999-01-01'
GROUP BY f.nm_func

-- 10. A Biblioteca recebeu a visita de um grupo de alunos, mas após a visita foi
-- verificado desaparecimento de três livros, as obras que sumiram do acervo foram
-- ‘Filho Nativo’, ‘Vidas Secas’ e ‘Dom Casmurro’, com isto será necessária a alteração
-- da quantidade de livros no estoque de cada obra.

-- Atualização da obra 'Filho Nativo'
UPDATE Estoque
SET qtd_livro = qtd_livro - 1
WHERE id_obra = (SELECT id_obra FROM Obra WHERE titulo_obra = 'Filho Nativo');
-- Atualização da obra 'Vidas Secas'
UPDATE Estoque
SET qtd_livro = qtd_livro - 1
WHERE id_obra = (SELECT id_obra FROM Obra WHERE titulo_obra = 'Vidas Secas');
-- Atualização da obra 'Dom Casmurro'
UPDATE Estoque
SET qtd_livro = qtd_livro - 1
WHERE id_obra = (SELECT id_obra FROM Obra WHERE titulo_obra = 'Dom Casmurro');
SELECT titulo_obra, qtd_livro AS quantidade_livro
FROM Obra
INNER JOIN Estoque ON Obra.id_obra = Estoque.id_obra
WHERE titulo_obra IN ('Filho Nativo', 'Vidas Secas', 'Dom Casmurro');

-- 11. A Recepcionista Claudia Cristina não conseguiu terminar o cadastro de
-- cinco usuários que passaram pela Biblioteca, foi solicitado a inserção desses
-- usuários. São eles:
-- ● 31, Alfredo Tenttoni, Rua Amazonas 58, Pirai, 6549-5421, 02170-251,
-- 294.264.875-32
-- ● 32, Cindy Crall, Rua Ipiranga 123, Vila Cristal, 5846-6577, 02182-637,
-- 122.147.655-49
-- ● 33, Rubens Pardo, Avenida dos Monges 51, Campo Grande, 5184-8978,
-- 52412-365, 654.586.472-98
-- ● 34, Carlos Pracidelli, Travessa dos Irmãos 48, Cotia, 8945-7986,
-- 23124-005, 341.251.651-75
-- ● 35, Ernesto Coimbra, Avenida Ampére 414, Jardim Elvira, 5844-2654,
-- 05728-368, 193.107.214-35

INSERT IGNORE INTO Usuario (nm_usuario, cpf)
VALUES
('Alfredo Tenttoni', '294.264.875-32'),
('Cindy Crall', '122.147.655-49'),
('Rubens Pardo', '654.586.472-98'),
('Carlos Pracidelli', '341.251.651-75'),
('Ernesto Coimbra', '193.107.214-35');
INSERT IGNORE INTO Tel_Usuario (id_usuario, telefone)
SELECT u.id_usuario, t.telefone
FROM Usuario u
JOIN (
SELECT '294.264.875-32' AS cpf, '6549-5421' AS telefone
UNION ALL SELECT '122.147.655-49', '5846-6577'
UNION ALL SELECT '654.586.472-98', '5184-8978'
UNION ALL SELECT '341.251.651-75', '8945-7986'
UNION ALL SELECT '193.107.214-35', '5844-2654'
) AS t ON u.cpf = t.cpf;
INSERT IGNORE INTO end_usuario (id_usuario, numero, rua, bairro, CEP)
SELECT u.id_usuario, e.numero, e.rua, e.bairro, e.CEP
FROM Usuario u
JOIN (
SELECT '294.264.875-32' AS cpf, '58' AS numero, 'Rua Amazonas' AS rua, 'Pirai' AS
bairro, '02170-251' AS CEP
UNION ALL SELECT '122.147.655-49', '123', 'Rua Ipiranga', 'Vila Cristal', '02182-637'
UNION ALL SELECT '654.586.472-98', '51', 'Avenida dos Monges', 'Campo Grande',
'52412-365'
UNION ALL SELECT '341.251.651-75', '48', 'Travessa dos Irmãos', 'Cotia', '23124-005'
UNION ALL SELECT '193.107.214-35', '414', 'Avenida Ampére', 'Campo Grande',
'05728-368'
) AS e ON u.cpf = e.cpf;

-- 12. Financeiro solicitou a inserção do valor individual de cada obra. Crie um
-- campo com o nome Valor_Livro na tabela Obra. Defina o tipo de dados que poderá ser
-- aceito e o valor de cada título.

ALTER TABLE
obra
ADD COLUMN
valor_livro decimal(10,2);
UPDATE
obra
INNER JOIN
estoque ON obra.id_obra = estoque.id_obra
SET obra.valor_livro = estoque.vlr_unitario;
select * from obra;

-- 13. A Consultoria verificou que o campo Multa_Atraso está com o tamanho Varchar(2), foi solicitada a alteração do campo para Varchar(3).

ALTER TABLE devolucao
MODIFY mlt_atraso VARCHAR(3);

-- 14. Foi verificado que o campo Multa_Atraso está com os registros
-- preenchidos de forma errada, foi solicitada a alteração dos registros que forem 0 para
-- Não e 1 para SIM.

ALTER TABLE devolucao
MODIFY COLUMN mlt_atraso VARCHAR(20) NOT NULL;
SET SQL_SAFE_UPDATES = 0;
UPDATE devolucao
SET mlt_atraso = 'não'
WHERE mlt_atraso = '0';
UPDATE devolucao
SET mlt_atraso = 'sim'
WHERE mlt_atraso = '1';

-- 15. A Diretoria solicitou a lista de todos os livros que já foram emprestados
-- mas foram entregues com atraso e os respectivos os nomes dos funcionários que
-- fizeram os empréstimos.

SELECT Devolucao.id_emprestimo, Devolucao.mlt_atraso AS multa_atraso,
Funcionario.nm_func AS nome_funcionario, Obra.titulo_obra
FROM Devolucao
INNER JOIN Emprestimo ON Devolucao.id_emprestimo = Emprestimo.id_emprestimo
INNER JOIN Funcionario ON Devolucao.id_func = Funcionario.id_func
INNER JOIN Obra ON Devolucao.id_obra = Obra.id_obra
WHERE Devolucao.mlt_atraso = "sim";

-- 16. A Gerência solicitou a lista de todos os livros, cujos autores não são
-- brasileiros, que já foram devolvidos e o valor total de cada livro. O Financeiro
-- solicitou a lista de todas as obras que tiveram data de publicação menor que
-- 04/03/2023, sua respectiva quantidade e o seu valor unitário.

SET SQL_SAFE_UPDATES = 0;
ALTER TABLE autor ADD COLUMN nacionalidade VARCHAR(10);
UPDATE autor
SET nacionalidade =
CASE
WHEN nm_autor IN('Alberto Mussa', 'Aluísio de Azevedo', 'Ariano Suassuna', 'Autran
Dourado', 'Bernardo Guimarães', 'Casimiro de Abreu',
'Carlos Heitor Cony', 'Clarice Lispector', 'Denis
Mandarino') THEN 'BR'
WHEN nm_autor IN('George Raymond Richard Martin', 'Edgar Allan Poe', 'Rick
Riordan') THEN 'US'
WHEN nm_autor = 'John Ronald Reuel Tolkien' THEN 'UK'
WHEN nm_autor = 'Clive Staples Lewis' THEN 'IE'
WHEN nm_autor = 'Alexandre Dumas' THEN 'FR'
ELSE 'Desconhecido'
END;
SELECT
o.titulo_obra,
o.id_obra,
a.id_autor,
a.nm_autor AS nome_autor,
a.nacionalidade,
SUM(e.vlr_unitario) AS valor_total,
COUNT(d.id_devolucao) AS quantidade_devolucao
FROM devolucao d
LEFT JOIN estoque e ON e.id_estoque = d.id_estoque
LEFT JOIN obra o ON d.id_obra = o.id_obra
LEFT JOIN autor_obra ao ON ao.id_obra = o.id_obra
LEFT JOIN autor a ON ao.id_autor = a.id_autor
WHERE a.nacionalidade != 'BR'
GROUP BY
o.id_obra,
a.id_autor
ORDER BY quantidade_devolucao DESC;
SELECT
o.titulo_obra,
o.dt_publi AS data_publicacao,
e.qtd_livro AS quantidade_livro,
e.vlr_unitario AS valor_unitario
FROM estoque e
LEFT JOIN
obra o ON e.id_obra = o.id_obra
WHERE o.dt_publi < '2023-03-04'
ORDER BY o.dt_publi DESC;

-- 17. A área de RH solicitou a lista de todos os funcionários separados por ativos
-- ou não, seus respectivos cargos e salários.

SELECT
f.nm_func AS funcionario,
c.nm_cargo AS cargo,
c.salario AS salario,
CASE
WHEN f.dt_demissao = '9999-01-01' THEN 'Ativo'
ELSE 'Inativo'
END AS status
FROM
funcionario f
LEFT JOIN
cargo c ON f.id_cargo = c.id_cargo
ORDER BY
f.dt_demissao DESC, salario DESC;

-- 18. A Diretoria solicitou a lista de todos os funcionários da Biblioteca com seus
-- respectivos departamentos que tem idade
-- entre 30 e 40 anos.

-- Para essa questão foram criadas varias datas de nascimento e depois foram derivadas as idades
-- Adiciona a coluna "data de nascimento" à tabela
ALTER TABLE funcionario
ADD COLUMN data_nascimento_func DATE;
-- mudar para data de nascimento
-- Atualiza os valores da coluna "idade" com idades fictícias
-- pensamos em aleatorizar
UPDATE funcionario
SET data_nascimento_func =
CASE
WHEN id_func = 1 THEN '1990-01-15'
WHEN id_func = 2 THEN '1985-05-22'
WHEN id_func = 3 THEN '1988-11-10'
WHEN id_func = 4 THEN '1992-07-03'
WHEN id_func = 5 THEN '1982-04-18'
WHEN id_func = 6 THEN '1995-09-07'
WHEN id_func = 7 THEN '1987-12-25'
WHEN id_func = 8 THEN '1993-03-30'
WHEN id_func = 9 THEN '1984-02-16'
WHEN id_func = 10 THEN '1991-06-09'
WHEN id_func = 11 THEN '1989-02-28'
END;
-- a query
SELECT
f.id_func,
f.nm_func,
f.data_nascimento_func,
CAST(DATEDIFF(CURRENT_DATE, f.data_nascimento_func) / 365 AS SIGNED) AS
idade,
d.nm_dept
FROM funcionario f
JOIN departamento d ON f.id_dept = d.id_dept
WHERE DATEDIFF(CURRENT_DATE, f.data_nascimento_func) / 365 BETWEEN 30 AND
40;

-- 19. A Recepção solicitou uma lista com o código do livro, nome do livro cujo
-- valor do livro seja maior que R$ 90,00.

SELECT o.id_obra, o.titulo_obra, e.vlr_unitario
FROM obra AS o
INNER JOIN estoque AS e ON e.id_obra = o.id_obra
WHERE e.vlr_unitario > 90.00

-- 20. A área de RH solicitou a atualização do salário do Auxiliar Financeiro de
-- 12% sobre o seu salário atual. A Gerência solicitou uma lista de todas as Obras, que
-- contenham a letra “C” ordenadas por gênero data de publicação entre 2021 e 2023.

-- Atualização do salário do Auxiliar Financeiro de 12% sobre o seu salário atual.
UPDATE Cargo
SET salario = salario * 1.12
WHERE nm_cargo = 'Auxiliar Financeiro';
SELECT nm_cargo AS nome_cargo, salario
FROM Cargo
WHERE nm_cargo = 'Auxiliar Financeiro';
-- Insert de valores.
INSERT INTO obra (id_editora, titulo_obra, num_publi, dt_publi) VALUES
('1', 'C1 Teste Teste', '52', '2021-05-10'),
('2', 'C2 123 Teste', '5', '2022-12-31'),
('1', 'C3 Teste', '22', '2022-05-10'),
('2', 'C4 Teste Teste', '2', '2023-12-31');
INSERT INTO genero_obra (id_obra, id_genero)
VALUES
("31", "2"),
("32", "6"),
("33", "2"),
("34", "6");
-- A lista de todas as Obras, que contenham a letra “C” ordenadas por gênero e data de publicação entre 2021 e 2023.
SELECT Obra.titulo_obra, Genero.nm_genero AS nome_genero, Obra.dt_publi AS
data_publicacao
FROM Genero_Obra
INNER JOIN Genero ON Genero.id_genero = Genero_Obra.id_genero
INNER JOIN Obra ON Obra.id_obra = Genero_Obra.id_obra
WHERE Obra.titulo_obra LIKE 'C%'
AND YEAR(Obra.dt_publi) BETWEEN 2021 AND 2023
ORDER BY Genero.nm_genero, Obra.dt_publi;

-- 21. A Recepção solicitou uma lista como todos os funcionários da Biblioteca
-- com código, nome, e departamento, classificado pelo nome do funcionário que não
-- emprestaram nenhum livro. A Biblioteca solicitou uma lista que exiba a quantidade de
-- logradouros de usuários agrupados por número do CEP.

SELECT
f.id_func AS codigo_funcionario,
f.nm_func AS nome_funcionario,
d.nm_dept AS nome_departamento,
COUNT(e.id_emprestimo) AS quantidade_emprestimo
FROM funcionario f
LEFT JOIN emprestimo e ON e.id_func = f.id_func
LEFT JOIN departamento d ON d.id_dept = f.id_dept
GROUP BY nome_funcionario, codigo_funcionario, nome_departamento
HAVING quantidade_emprestimo = 0
ORDER BY nome_funcionario;
SELECT
CEP,
COUNT(DISTINCT CONCAT(rua, ' ', numero)) AS quantidade_logradouro
FROM end_usuario
GROUP BY CEP
ORDER BY quantidade_logradouro DESC;

-- 22. Diretoria solicitou uma lista que exiba a quantidade de endereços
-- agrupados por usuário. Hoje é aniversario da biblioteca e para comemorar foram
-- comprados presentes a todos os usuários que foram os primeiros a utilizar a
-- biblioteca, o gerente Carlos mendes pediu a relação da primeira pessoa a reservar,
-- pegar emprestado e devolver um livro e suas respectivas informações para que possa
-- ser entrado em contato com ele.

SELECT
u.id_usuario,
u.nm_usuario,
ts.telefone,
e.bairro,
e.rua,
e.numero,
MIN(r.dt_reserva) AS primeira_reserva,
MIN(em.dt_emprestimo) AS primeiro_emprestimo,
MIN(d.dt_devolucao) AS primeira_devolucao,
COUNT(e.id_usuario) AS quantidade_enderecos
FROM
usuario u
INNER JOIN
tel_usuario ts ON u.id_usuario = ts.id_usuario
LEFT JOIN
end_usuario e ON u.id_usuario = e.id_usuario
LEFT JOIN
reserva r ON u.id_usuario = r.id_usuario
LEFT JOIN
emprestimo em ON u.id_usuario = em.id_usuario
LEFT JOIN
devolucao d ON u.id_usuario = d.id_usuario
WHERE
r.id_usuario IS NOT NULL
GROUP BY
u.id_usuario, u.nm_usuario, ts.telefone, e.bairro, e.rua, e.numero
ORDER BY
primeira_reserva ASC, primeiro_emprestimo ASC, primeira_devolucao ASC
LIMIT 1;

-- 23. Foi solicitado pela diretoria saber quantas obras cada editora tem na
-- biblioteca.

SELECT e.id_editora, e.nm_editora, COUNT(o.id_obra) AS quantidade_obras
FROM editora e
LEFT JOIN obra o ON e.id_editora = o.id_editora
GROUP BY e.id_editora, e.nm_editora;

-- 24. Foi solicitado a informação de todos os usuários que morem em uma
-- avenida, e ainda, que seja mostrado o nome do usuário, CPF e logradouro em ordem
-- de CPF do maior para o menor

SELECT u.nm_usuario, u.CPF, ed.bairro, ed.rua, ed.numero
FROM usuario AS u
INNER JOIN end_usuario AS ed ON ed.id_usuario = u.id_usuario
WHERE rua LIKE 'Avenida%'
ORDER BY CPF DESC;

-- 25. Chegou na biblioteca uma mensagem urgente da Camila pedindo um
-- relatório contendo a informação de todos os livros que foram emprestados mais de
-- uma vez nos anos de 2011 a 2013 agrupados pelo nome do livro.

-- Insert de valores na tabela Emprestimo
INSERT INTO Emprestimo (id_func, id_usuario, id_estoque,
id_obra, dt_emprestimo, hr_emprestimo,
dt_entrega) VALUES
(1, 1, 1, 31, '2011-02-10', '10:00:00', '2011-02-15'),
(1, 1, 4, 32, '2013-10-25', '20:20:00', '2012-10-22'),
(2, 2, 2, 31, '2011-03-20', '11:30:00', '2011-03-25'),
(3, 3, 3, 32, '2012-06-05', '09:45:00', '2012-06-10'),
(1, 1, 4, 33, '2013-07-15', '14:20:00', '2013-07-20'),
(2, 2, 5, 33, '2013-08-10', '16:00:00', '2013-08-15'),
(3, 3, 6, 34, '2013-11-05', '10:15:00', '2013-11-10'),
(1, 1, 7, 32, '2011-04-10', '13:00:00', '2011-04-15'),
(2, 2, 8, 34, '2012-09-20', '11:30:00', '2012-09-25');
-- Todos os livros que foram emprestados mais de uma vez nos anos de 2011 a 2013 agrupados pelo nome do livro.
SELECT Obra.titulo_obra,
MIN(Emprestimo.dt_emprestimo) AS primeira_data_emprestimo,
COUNT(Emprestimo.id_emprestimo) AS total_emprestimos
FROM Emprestimo
INNER JOIN Obra ON Emprestimo.id_obra = Obra.id_obra
WHERE YEAR(Emprestimo.dt_emprestimo) BETWEEN 2011 AND 2013
GROUP BY Obra.titulo_obra
HAVING COUNT(Emprestimo.id_emprestimo) > 1;

-- 26. O Financeiro pediu para apresentar o valor médio dos livros e informar
-- quais são os que estão abaixo dessa media, referente a devolução e empréstimo.

SELECT
emp.id_obra,
o.titulo_obra,
est.vlr_unitario AS valor_obra,
(SELECT AVG(vlr_unitario) FROM estoque) AS media_geral
FROM emprestimo emp
INNER JOIN devolucao d ON d.id_obra = emp.id_obra
INNER JOIN estoque est ON emp.id_obra = est.id_obra
INNER JOIN obra o ON emp.id_obra = o.id_obra
WHERE est.vlr_unitario < (SELECT AVG(vlr_unitario) FROM estoque)
GROUP BY
emp.id_obra,
o.titulo_obra,
valor_obra
ORDER BY est.vlr_unitario DESC;

-- 27. Carlos pediu que seja feita uma pesquisa informando de todos os usuários
-- que tem cadastro na biblioteca e que nunca levaram livros mostrar o nome de todos
-- em Maiúsculas.

SELECT
UPPER(u.nm_usuario) AS nome_maiusculo
FROM
usuario u
LEFT JOIN
emprestimo e ON u.id_usuario = e.id_usuario
WHERE
e.id_usuario IS NULL;

-- 28. A recepção pediu para verificar quais os usuários que já pegaram mais de 3
-- livros, e em caso positivo, mostrar nomes e quais livros, ordenando pelo CEP
-- (crescente).

SELECT
u.id_usuario,
u.nm_usuario,
e.cep,
COUNT(emp.id_emprestimo) AS numero_emprestimos
FROM usuario u
JOIN end_usuario e ON u.id_usuario = e.id_usuario
JOIN emprestimo emp ON u.id_usuario = emp.id_usuario
GROUP BY u.id_usuario, u.nm_usuario, e.cep
HAVING COUNT(emp.id_emprestimo) > 3
ORDER BY e.cep ASC;

-- 29. A diretoria pediu que fosse feito uma análise do estoque, apresentando
-- uma lista com todos os livros que já foram reservados e emprestados e, mostrar
-- quantos estão disponíveis classificados por Gênero.

SELECT g.nm_genero,o.titulo_obra, -- selecao do titulo, genero
COUNT(r.id_reserva) AS qtd_reservado, -- contando todas as quantidades de reservas na tabela reserva
COUNT(e.id_emprestimo) AS qtd_emprestado, -- contando todas as quantidades de emprestimo na tabela emprestimo
(es.qtd_Livro - COUNT(e.id_emprestimo) - COUNT(r.id_reserva)) AS
Qtd_Disponivel -- realizando calculo de subtração entre a qtd de livro com qtd emprestimo e reserva
FROM estoque AS es
INNER JOIN reserva AS r ON r.id_estoque = es.id_estoque
INNER JOIN emprestimo AS e ON e.id_estoque = es.id_estoque
INNER JOIN obra AS o ON o.id_obra = e.id_obra
INNER JOIN genero_obra AS gn ON gn.id_obra = o.id_obra
INNER JOIN genero AS g ON g.id_genero = gn.id_genero
GROUP BY o.titulo_obra, g.nm_genero, es.qtd_Livro
ORDER BY nm_genero;

-- 30. A biblioteca foi comprar mais livros para aumentar seu acervo, mas a
-- editora Saraiva aumentou em 16% o valor de seus livros, atualize os preços dos livros
-- da editora na porcentagem designada.

-- Aumento em 16% no valor dos livros da editora Saraiva.
UPDATE Estoque
SET vlr_unitario = vlr_unitario * 1.16
WHERE id_obra IN (SELECT id_obra FROM Obra WHERE id_editora =
(SELECT id_editora FROM Editora WHERE nm_editora = 'Saraiva'));
-- Select sobre os valores atualizados.
SELECT titulo_obra, Editora.nm_editora AS nome_editora, vlr_unitario AS valor_unitario
FROM Estoque
INNER JOIN Obra ON Estoque.id_obra = Obra.id_obra
INNER JOIN Editora ON Obra.id_editora = Editora.id_editora
WHERE Editora.nm_editora = 'Saraiva';

-- 31. Foi solicitado apresentarmos quais as 5 obras que tiveram menos
-- publicações e as 5 de maior, ainda, mostrar qual o autor, editora, nome do livro e
-- quantidade de publicações em ordem decrescente.

--  faz uma subquery que retorna todas as obras ranqueadas em 2 listas
WITH ranked_obras AS (
SELECT
o.titulo_obra AS nome_da_obra,
e.nm_editora AS editora,
a.nm_autor AS autor,
o.num_publi AS quantidade_publicacoes,
--  guarda de forma ascendente as publicações com menos publicações
ROW_NUMBER() OVER (ORDER BY o.num_publi ASC) AS
rank_menos_publicacoes,
--  guarda de forma descendente as publicações com menos publicações
ROW_NUMBER() OVER (ORDER BY o.num_publi DESC) AS
rank_mais_publicacoes
FROM obra o
JOIN editora e ON o.id_editora = e.id_editora
JOIN autor_obra ra ON o.id_obra = ra.id_obra
JOIN autor a ON ra.id_autor = a.id_autor
)
SELECT
nome_da_obra,
editora,
autor,
quantidade_publicacoes
-- pega as 5 primeiras obras ascendentes e descentes mostrando assim as 5 maiores e menores
FROM ranked_obras
WHERE rank_menos_publicacoes <= 5 OR rank_mais_publicacoes <= 5;

-- 32. Fazem cento e noventa e três meses que o instituto bibliográfico brasileiro 
-- surgiu. Para comemorar a diretoria pediu a relação de todos os usuários que tem o
-- cpf com o começo 193 que receberão um presente de comemoração. Para isto, foi
-- solicitado informar o nome e o cpf de todos os usuários que estejam nesse padrão
-- mas mostrar cpf os 3 primeiros dígitos e os dois últimos os do meio apresentar um "*"
-- pois a diretoria quer preservar essas informações que são sigilosas. 

SELECT nm_usuario,
CONCAT(LEFT(CPF, 3), '***', RIGHT(CPF, 2)) AS CPF
FROM usuario
WHERE CPF LIKE '193%';

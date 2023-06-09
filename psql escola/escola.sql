 
BEGIN;


--DROP TABLE tab_escolas CASCADE;
CREATE TABLE tab_escolas (
      codigo_escola             CHAR(4)      	NOT NULL,
      nome_escola               VARCHAR(40)  	NOT NULL,
      diretor_escola            NUMERIC(5)	NOT NULL,
      PRIMARY KEY (codigo_escola),
      UNIQUE (diretor_escola),
      UNIQUE (nome_escola));

--DROP TABLE tab_fones_escolas CASCADE;
CREATE TABLE tab_fones_escolas(
      codigo_escola             CHAR(4)		NOT NULL,
      fone_escola               NUMERIC(10)  	NOT NULL,
      PRIMARY KEY (codigo_escola, fone_escola),
      FOREIGN KEY (codigo_escola) REFERENCES tab_escolas(codigo_escola));

--DROP TABLE tab_cursos CASCADE;
CREATE TABLE tab_cursos (
      codigo_curso              NUMERIC(3)   	NOT NULL,
      nome_curso                VARCHAR(40)  	NOT NULL, 
      descricao_curso           VARCHAR(200) 	NOT NULL,
      horas_aula_curso          NUMERIC(4)   	NOT NULL,
      escola_curso              CHAR(4)		NOT NULL,
      coordenador_curso         NUMERIC(5)	NOT NULL,
      PRIMARY KEY (codigo_curso),
      UNIQUE (nome_curso),
      UNIQUE (coordenador_curso),
      FOREIGN KEY (escola_curso) REFERENCES tab_escolas(codigo_escola),
      CHECK (horas_aula_curso between 20 AND 100));

--DROP TABLE tab_alunos CASCADE;
CREATE TABLE tab_alunos (
      id_aluno                  serial	 	NOT NULL, -- identificador gerado pelo SGBD para o aluno j� que ele n�o tem atributo obrigat�rio identificador natural
      nome_aluno                VARCHAR(40)  	NOT NULL,
      cart_identidade_aluno     VARCHAR(12) 	NULL,
      cpf_aluno                 VARCHAR(14) 	NULL,
      end_aluno                 VARCHAR(200) 	NOT NULL,
      sexo_aluno                CHAR(1)	        NOT NULL,
      data_nasc_aluno           DATE    	NOT NULL,
      PRIMARY KEY (id_aluno),
      UNIQUE (cpf_aluno),
      UNIQUE (cart_identidade_aluno),
      CHECK  (sexo_aluno='M' OR sexo_aluno='F'),
      CHECK  (cart_identidade_aluno is not null or cpf_aluno is not null));

--DROP TABLE tab_fones_alunos CASCADE;
CREATE TABLE tab_fones_alunos (
      id_aluno                  INTEGER	        NOT NULL,
      fone_aluno                NUMERIC(10)  	NOT NULL,
      PRIMARY KEY (id_aluno,fone_aluno),
      FOREIGN KEY (id_aluno) REFERENCES tab_alunos(id_aluno));

--DROP TABLE tab_funcionarios CASCADE;
CREATE TABLE tab_funcionarios (
      matricula_funcionario     NUMERIC(5)  	NOT NULL,
      nome_funcionario          VARCHAR(40) 	NOT NULL,
      cart_identid_funcionario  VARCHAR(12) 	NULL,
      cpf_funcionario           VARCHAR(14) 	NULL,
      endereco_funcionario      VARCHAR(200)	NOT NULL,
      sexo_funcionario          CHAR(1) 	NOT NULL,
      data_nasc_funcionario     DATE    	NOT NULL,
      data_admissao_funcionario DATE 		NOT NULL,
      data_demissao_funcionario DATE            NULL,
      escola_funcionario        CHAR(4) 	NOT NULL,
      PRIMARY KEY (matricula_funcionario),
      UNIQUE (cart_identid_funcionario),
      UNIQUE (cpf_funcionario),
      FOREIGN KEY (escola_funcionario) REFERENCES tab_escolas (codigo_escola),
      CHECK (cpf_funcionario is not null or cart_identid_funcionario is not null),
      CHECK (sexo_funcionario ='M' OR sexo_funcionario ='F'));

--DROP TABLE tab_fones_funcionarios CASCADE;
CREATE TABLE tab_fones_funcionarios (
      matricula_funcionario     NUMERIC(5)  	NOT NULL,
      fone_funcionario          NUMERIC(10) 	NOT NULL,
      PRIMARY KEY (matricula_funcionario, fone_funcionario),
      FOREIGN KEY (matricula_funcionario) REFERENCES tab_funcionarios(matricula_funcionario));

--DROP TABLE tab_professores CASCADE;
CREATE TABLE tab_professores (
      matricula_professor       NUMERIC(5) 	NOT NULL,
      PRIMARY KEY (matricula_professor),
      FOREIGN KEY (matricula_professor) REFERENCES tab_funcionarios(matricula_funcionario));

--DROP TABLE tab_disciplinas CASCADE;
CREATE TABLE tab_disciplinas (
      codigo_disciplina         CHAR(7)    	NOT NULL,
      nome_disciplina           VARCHAR(40) 	NOT NULL,
      horas_aula_disciplina     NUMERIC(1)  	NOT NULL,
      escola_disciplina         CHAR(4)		NOT NULL,
      PRIMARY KEY (codigo_disciplina),
      FOREIGN KEY (escola_disciplina) REFERENCES tab_escolas(codigo_escola),
      CHECK (horas_aula_disciplina IN (2,4,6,8,10,12)));


--DROP TABLE tab_disciplinas_cursos CASCADE;
CREATE TABLE tab_disciplinas_cursos (
      codigo_disciplina         CHAR(7)    	NOT NULL,
      codigo_curso              NUMERIC(3) 	NOT NULL,
      PRIMARY KEY (codigo_disciplina, codigo_curso),
      FOREIGN KEY (codigo_disciplina) REFERENCES tab_disciplinas(codigo_disciplina),
      FOREIGN KEY (codigo_curso) REFERENCES tab_cursos(codigo_curso));

--DROP TABLE tab_turmas CASCADE;
CREATE TABLE tab_turmas (
      id_turma                  SERIAL          NOT NULL,
      codigo_disciplina_turma   CHAR(7)         NOT NULL,
      codigo_turma              CHAR(3)         NOT NULL,
      ano_turma                 NUMERIC(4)      NOT NULL,
      semestre_turma            NUMERIC(1)      NOT NULL,
      PRIMARY KEY (id_turma),
      UNIQUE (codigo_disciplina_turma,codigo_turma,ano_turma,semestre_turma),
      FOREIGN KEY (codigo_disciplina_turma) REFERENCES tab_disciplinas(codigo_disciplina),
      CHECK (semestre_turma = 1 OR semestre_turma = 2));

--DROP TABLE tab_tipos_capacitacoes CASCADE;
CREATE TABLE tab_tipos_capacitacoes (
      tipo_capacitacao          NUMERIC(3)      NOT NULL,
      descricao_capacitacao     VARCHAR(200)    NOT NULL,
      titulo_obtido_capacitacao CHAR(1)         NULL,
      CHECK (titulo_obtido_capacitacao in ('Bacharel', 'Especialista', 'Mestre', 'Doutor', 'Pos-Doutor')),
      PRIMARY KEY (tipo_capacitacao));

--DROP TABLE tab_capacitacoes_professores CASCADE;
CREATE TABLE tab_capacitacoes_professores (
      matricula_professor       NUMERIC(5)      NOT NULL,
      numero_capacit_prof       INTEGER         NOT NULL,
      nome_capacit_prof         VARCHAR(50)     NOT NULL,
      tipo_capacit_prof         NUMERIC(3)      NOT NULL,
      responsavel_capacit_prof  VARCHAR(50)     NULL,
      carga_horaria_capacit_prof NUMERIC(5)     NULL,
      data_ini_capacit_prof     DATE            NULL,
      data_fim_capacit_prof     DATE            NULL,
      observacao_capacit_prof   VARCHAR(200)    NULL,
      PRIMARY KEY (matricula_professor, numero_capacit_prof),
      FOREIGN KEY (tipo_capacit_prof) REFERENCES tab_tipos_capacitacoes (tipo_capacitacao),
      FOREIGN KEY (matricula_professor) REFERENCES tab_professores(matricula_professor));

--DROP TABLE tab_aulas CASCADE;
CREATE TABLE tab_aulas (
      id_turma_aula             INTEGER	        NOT NULL,
      dia_semana_aula           CHAR(3)         NOT NULL,
      hora_inicio_aula          TIME	        NOT NULL,
      hora_fim_aula             TIME	        NOT NULL,
      tipo_aula                 CHAR(1)         NOT NULL,
      area_sala_aula            VARCHAR(3)      NOT NULL,
      bloco_sala_aula           CHAR(1)	        NOT NULL,
      numero_sala_aula          NUMERIC(3)      NOT NULL,
      professor_aula            NUMERIC(5)      NULL,
      PRIMARY KEY (id_turma_aula, dia_semana_aula, hora_inicio_aula),
      FOREIGN KEY (id_turma_aula) REFERENCES tab_turmas (id_turma),
      FOREIGN KEY (professor_aula) REFERENCES tab_professores (matricula_professor),
      CHECK (area_sala_aula IN ('I','II','III','IV','V')),
      CHECK (bloco_sala_aula between 'A' AND 'Z'),
      CHECK (dia_semana_aula IN ('Seg','Ter','Qua','Qui','Sex','Sab')),
      CHECK (tipo_aula='P' OR tipo_aula='L')); 

--DROP TABLE tab_alunos_cursos CASCADE;
CREATE TABLE tab_alunos_cursos (
      id_aluno                  INTEGER         NOT NULL,
      codigo_curso              NUMERIC(3)      NOT NULL,
      matricula_aluno_curso     NUMERIC(14)     NOT NULL,
      ano_inicio_aluno_curso    NUMERIC(4)      NOT NULL,
      ano_conclusao_aluno_curso NUMERIC(4)      NULL,
      PRIMARY KEY (matricula_aluno_curso),
      UNIQUE (id_aluno, codigo_curso),
      FOREIGN KEY (id_aluno) REFERENCES tab_alunos (id_aluno),
      FOREIGN KEY (codigo_curso) REFERENCES tab_cursos (codigo_curso));

--DROP TABLE tab_disciplinas_pre_req CASCADE;
CREATE TABLE tab_disciplinas_pre_req (
      codigo_disciplina         CHAR(7)	        NOT NULL, 
      codigo_disciplina_pre_req CHAR(7)	        NOT NULL,
      PRIMARY KEY  (codigo_disciplina, codigo_disciplina_pre_req),
      FOREIGN KEY  (codigo_disciplina) REFERENCES tab_disciplinas (codigo_disciplina),
      FOREIGN KEY  (codigo_disciplina_pre_req) REFERENCES tab_disciplinas(codigo_disciplina));
       
--DROP TABLE tab_alunos_turmas CASCADE;
CREATE TABLE tab_alunos_turmas (
      matricula_aluno_curso       NUMERIC(14)   NOT NULL,	
      id_turma                    INTEGER       NOT NULL,
      situacao_aluno_turma        CHAR(1)       NOT NULL DEFAULT 'A',
      n1_aluno_turma              NUMERIC(3,1)  NOT NULL DEFAULT 0.0,
      n2_aluno_turma              NUMERIC(3,1)  NOT NULL DEFAULT 0.0,
      qtd_frequencia_aluno_turma  NUMERIC(3)    NOT NULL DEFAULT 0,
      media_final_aluno_turma     NUMERIC(3,1)  NOT NULL DEFAULT 0,
      resultado_final_aluno_turma CHAR(3)       NULL,
      CHECK (situacao_aluno_turma in ('A', 'C', 'T')),
      CHECK (resultado_final_aluno_turma in ('AP', 'RF', 'RN', 'RMF')),
      PRIMARY KEY (matricula_aluno_curso, id_turma),
      FOREIGN KEY (matricula_aluno_curso) REFERENCES 
                            tab_alunos_cursos (matricula_aluno_curso),
      FOREIGN KEY (id_turma) REFERENCES tab_turmas (id_turma));

--DROP TABLE tab_frequencias_mensais_alunos_turmas CASCADE;
CREATE TABLE tab_frequencias_mensais_alunos_turmas (
      matricula_aluno_curso     NUMERIC(14)     NOT NULL,	
      id_turma                  INTEGER	        NOT NULL,
      mes_frequencia            NUMERIC(1)      NOT NULL,
      qtd_frequencia            NUMERIC(3)      NOT NULL DEFAULT 0,
      PRIMARY KEY (matricula_aluno_curso, id_turma, mes_frequencia),
      FOREIGN KEY (matricula_aluno_curso, id_turma) REFERENCES 
				tab_alunos_turmas (matricula_aluno_curso, id_turma));

--DROP TABLE tab_professores_disciplinas CASCADE;
CREATE TABLE tab_professores_disciplinas (
      matricula_professor       NUMERIC(5)      NOT NULL,
      codigo_disciplina         CHAR(7)         NOT NULL,
      PRIMARY KEY (matricula_professor, codigo_disciplina),
      FOREIGN KEY (matricula_professor) REFERENCES tab_professores(matricula_professor),
      FOREIGN KEY (codigo_disciplina) REFERENCES tab_disciplinas(codigo_disciplina));

ALTER TABLE tab_escolas ADD FOREIGN KEY (diretor_escola) REFERENCES tab_professores (matricula_professor);

ALTER TABLE tab_cursos ADD FOREIGN KEY (coordenador_curso) REFERENCES tab_professores (matricula_professor);

END;

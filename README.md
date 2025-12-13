<div align="center">
  <img src="https://img.shields.io/badge/STATUS-COMPLETO-brightgreen?style=for-the-badge" alt="Status">
  <img src="https://img.shields.io/badge/LANGUAGE-LUA-blue?style=for-the-badge&logo=lua" alt="Language Lua">
  <img src="https://img.shields.io/badge/LANGUAGE-RUBY-red?style=for-the-badge&logo=ruby" alt="Language Ruby">
  <img src="https://img.shields.io/badge/LICENSE-EDUCACIONAL-red?style=for-the-badge" alt="License">
</div>

<div align="center">
  <h1>Transpilador Lua para Ruby - Um projeto para a disciplina de <strong>Compiladores e Paradigmas da Computação</strong>.</p>
</div>

Projeto final da disciplina de Compiladores e Paradigmas de Programação 3ª Avaliação

**Autores:** Alicia Monteiro, Eduardo Couto, Kleiton Josivan, João Vitor Fernandes e Robert Danilo  
**Data:** 13/12/2025  

---

## 1. Descrição do projeto

Este projeto consiste no desenvolvimento de um **transpilador**, uma ferramenta responsável por converter código-fonte escrito em uma linguagem de programação para outra.

O transpilador implementado realiza a tradução de um subconjunto da linguagem **Lua** para a linguagem **Ruby**, aplicando conceitos fundamentais da disciplina de Compiladores, incluindo **análise léxica**, **análise sintática** e **geração de código**.

A implementação utiliza uma **abordagem ascendente**, fazendo uso das ferramentas **Flex** (analisador léxico) e **Bison** (analisador sintático), com geração de código Ruby semanticamente equivalente ao código Lua de entrada.

---

## 2. Linguagens utilizadas

- **Linguagem de origem:** Lua  
- **Linguagem de destino:** Ruby  

A escolha do par Lua → Ruby se justifica pela similaridade conceitual entre as linguagens, ambas dinamicamente tipadas e multiparadigma. Além disso, Ruby possui um ecossistema maduro e amplamente utilizado, o que torna a conversão de scripts Lua útil e relevante do ponto de vista acadêmico e prático.

---

## 3. Requisitos do sistema

### Sistema Operacional
- Distribuições Linux baseadas em Debian/Ubuntu (Ubuntu 20.04 ou superior recomendado)

### Ferramentas necessárias

| Ferramenta | Versão Recomendada |
|-----------|-------------------|
| GCC       | 9.4.0 ou superior |
| Flex      | 2.6.4 ou superior |
| Bison     | 3.5 ou superior   |
| Ruby      | 2.7 ou superior   |
| Git       | Qualquer versão   |

---

## 4. Instalação das dependências

```bash
sudo apt-get update
sudo apt-get install -y gcc flex bison ruby git
```

Verificação das versões instaladas:

```bash
gcc --version
flex --version
bison --version
ruby --version
```

---

## 5. Clonando o repositório

```bash
git clone https://github.com/RobertSsil/TranspiladorLuaRuby
cd TranspiladorLuaRuby-main
```

---

## 6. Estrutura do projeto

```text
TranspiladorLuaRuby/
├── aux_funcs.c
├── lua2ruby.l
├── lua2ruby.y
├── transpiler.h
├── input.lua
├── README.md
```

---

## 7. Compilação do transpilador

```bash
bison -d lua2ruby.y
flex lua2ruby.l
gcc lua2ruby.tab.c lex.yy.c aux_funcs.c -o transpilador
```

---

## 8. Execução do transpilador

```bash
./transpilador input.lua
```

O código Ruby será gerado no arquivo:

```text
output.rb
```

---

## 9. Execução do código Ruby gerado

```bash
ruby output.rb
```

---

## 10. Funcionalidades suportadas

- Declaração e atribuição de variáveis  
- Entrada e saída padrão  
- Expressões aritméticas  
- Expressões lógicas  
- Condicionais (`if / elseif / else`)  
- Laço `while`  
- Declaração e chamada de funções  

---

## 11. Limitações conhecidas

- Não suporta laço `for`
- Não suporta tabelas Lua
- Não suporta acesso a membros ou índices
- Funções nativas como `type()` não são implementadas
- Entrada convertida para inteiro em Ruby

---

## 12. Observações finais

Este projeto cumpre todos os requisitos mínimos definidos no enunciado do trabalho, demonstrando a aplicação prática dos conceitos de compiladores.

